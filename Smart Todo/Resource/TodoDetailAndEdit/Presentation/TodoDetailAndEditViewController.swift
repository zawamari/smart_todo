//
//  TodoDetailAndEditViewController.swift
//  Smart Todo
//
//  Created by Marie on 2019/03/18.
//  Copyright © 2019 Marie. All rights reserved.
//

import UIKit
import RealmSwift

class TodoDetailAndEditViewController: UIViewController, OverCurrentTransitionable {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var todoDetailView: UIView!
    @IBOutlet weak var draggerImageView: UIImageView!
    @IBOutlet weak var draggerView: UIView!
    
    @IBOutlet weak var modalTitleLabel: UILabel!

    @IBOutlet weak var todoTitleView: UIView!
    @IBOutlet weak var todoTitleTextView: UITextView!

    @IBOutlet weak var openDetailView: UIView!
    @IBOutlet weak var openDetailLabel: UILabel!
    @IBOutlet weak var detailStackView: UIStackView!

    @IBOutlet weak var priorityView: UIView!
    @IBOutlet weak var priorityImageView: UIImageView!
    @IBOutlet weak var prioritySwitch: UISwitch!
    @IBOutlet weak var priorityLabel: UILabel!
    
    @IBOutlet weak var deadlineView: UIView!
    @IBOutlet weak var deadlineImageView: UIImageView!
    @IBOutlet weak var deadlineTextField: UITextField!
    @IBOutlet weak var deadlineLabel: UILabel!
    
    @IBOutlet weak var memoView: UIView!
    @IBOutlet weak var memoImageView: UIImageView!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var memoLabel: UILabel!
    
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var deleteLabel: UILabel!

    @IBOutlet weak var createView: UIView!
    @IBOutlet weak var createLabel: UILabel!

    @IBOutlet weak var updateView: UIView!
    @IBOutlet weak var updateLabel: UILabel!
    var percentThreshold: CGFloat = 0.3
    
    @IBOutlet weak var ViewBottom: NSLayoutConstraint!
    var interactor = OverCurrentTransitioningInteractor()
    
    // keyboard監視用
    var isObserving = false
    
    private var realm: Realm!
    var categoryId: Int = 0
    var todoId = 0

    // 登録か更新か
    var isRegisterationFlg = false

    private var todoDetail: Results<TodoItem>!
    
    let araigaki = UIColor(red: 223/255, green: 188/255, blue: 159/255, alpha: 1.0) //洗柿
    let koubai = UIColor(red: 235/255, green: 121/255, blue: 136/255, alpha: 1.0)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        transitioningDelegate = self
        modalPresentationStyle = .custom
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initRealm()
        initializedHiddenSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        initializedView()
        registObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Viewの表示時にキーボード表示・非表示時を監視していたObserverを解放する
        super.viewWillDisappear(animated)
        if isObserving {
            let notification = NotificationCenter.default
            notification.removeObserver(self)
            notification.removeObserver(self
                , name: UIResponder.keyboardWillShowNotification, object: nil)
            notification.removeObserver(self
                , name: UIResponder.keyboardWillHideNotification, object: nil)
            isObserving = false
        }
    }
    
    /// textfield以外をタップしたらキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        todoTitleTextView.resignFirstResponder()
        memoTextView.resignFirstResponder()
    }
    
    private func registObserver() {
        if !isObserving {
            let notification = NotificationCenter.default
            notification.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            notification.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
            isObserving = true
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification?) {
        // キーボード表示時の動作をここに記述する
        ViewBottom.constant = 350
        self.view.layoutIfNeeded()
    }
    @objc func keyboardWillHide(notification: NSNotification?) {
        // キーボード消滅時の動作をここに記述する
        ViewBottom.constant = 50
        self.view.layoutIfNeeded()
    }
    
    @IBAction func tapOpenDetail(_: UIGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            self.openDetailView.isHidden = true
            
            self.priorityView.isHidden = false
            self.memoTextView.isHidden = false
            self.deadlineView.isHidden = false
            self.memoView.isHidden = false
            self.detailStackView.layoutIfNeeded()
        }
    }
    
    private func initializedHiddenSetting() {
        openDetailView.isHidden = !isRegisterationFlg
        
        priorityView.isHidden = isRegisterationFlg
        memoTextView.isHidden = isRegisterationFlg
        deadlineView.isHidden = isRegisterationFlg
        memoView.isHidden = isRegisterationFlg
        
        deleteView.isHidden = isRegisterationFlg
        createView.isHidden = !isRegisterationFlg
        updateView.isHidden = isRegisterationFlg
    }
    
    private func setupViews() {
        todoDetailView.layer.cornerRadius = 12.0
        todoDetailView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let headerGesture = UIPanGestureRecognizer(target: self, action: #selector(headerDidScroll(_:)))
        todoDetailView.addGestureRecognizer(headerGesture)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(backgroundDidTap))
        backView.addGestureRecognizer(gesture)
        
        let detailTap = UITapGestureRecognizer(target: self, action: #selector(tapOpenDetail(_:)))
        openDetailView.addGestureRecognizer(detailTap)

    }
    
    private func initializedView() {
        draggerView.layer.cornerRadius = 3.0
        draggerImageView.image = UIImage.fontAwesomeIcon(name: .caretDown, style: .solid, textColor: .gray, size: CGSize(width: 60, height: 5))
        
        modalTitleLabel.text = "registTodoItem".localized
        
        todoTitleTextView.layer.cornerRadius = 5.0
        todoTitleTextView.layer.borderWidth = 0.5
        todoTitleTextView.layer.borderColor = UIColor.lightGray.cgColor
        todoTitleTextView.layer.masksToBounds = true
        
        openDetailLabel.text = "openDetail".localized
        
        prioritySwitch.addTarget(self, action: #selector(switchStateDidChange(_:)), for: .valueChanged)

        priorityImageView.image = UIImage.fontAwesomeIcon(name: .exclamation, style: .solid, textColor: koubai, size: CGSize(width: 25, height: 25))
        priorityLabel.text = "priority".localized
        prioritySwitch.isOn = false

        memoTextView.layer.cornerRadius = 5.0
        memoTextView.layer.borderWidth = 0.5
        memoTextView.layer.borderColor = UIColor.lightGray.cgColor
        memoTextView.layer.masksToBounds = true
        memoLabel.text = "memo".localized
        
        memoImageView.image = UIImage.fontAwesomeIcon(name: .pencilAlt, style: .solid, textColor: .gray, size: CGSize(width: 25, height: 25))
        
        deadlineTextField.addTarget(self, action: #selector(textFieldEditing(sender: )), for: UIControl.Event.allEvents)
        deadlineImageView.image = UIImage.fontAwesomeIcon(name: .calendarTimes, style: .solid, textColor: .gray, size: CGSize(width: 25, height: 25))
        deadlineLabel.text = "deadline".localized

        deleteLabel.layer.cornerRadius = 5.0
        deleteLabel.layer.masksToBounds = true
        deleteLabel.textColor = araigaki
        deleteLabel.text = "delete".localized

        updateLabel.layer.cornerRadius = 5.0
        updateLabel.layer.masksToBounds = true
        let updateGesture = UITapGestureRecognizer(target: self, action: #selector(update))
        updateLabel.addGestureRecognizer(updateGesture)
        updateLabel.text = "update".localized
        
        let createGesture = UITapGestureRecognizer(target: self, action: #selector(create))
        createLabel.addGestureRecognizer(createGesture)
        createLabel.text = "regist".localized
        createLabel.layer.cornerRadius = 5.0
        createLabel.layer.masksToBounds = true
        
        let deleteGesture = UITapGestureRecognizer(target: self, action: #selector(tapDelete))
        deleteLabel.addGestureRecognizer(deleteGesture)
        
        if !isRegisterationFlg {
            modalTitleLabel.text = "detailTodoItem".localized

            todoTitleTextView.text = todoDetail[0].todoTitle
            
            prioritySwitch.isOn = todoDetail[0].priority

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            if let date = todoDetail[0].deadlineDate {
                deadlineTextField.text = formatter.string(from: date)
            }
            memoTextView.text = todoDetail[0].memo
        }
    }
    
    static func make() -> TodoDetailAndEditViewController {
        let sb = UIStoryboard(name: "TodoDetailAndEdit", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! TodoDetailAndEditViewController
        return vc
    }
    
    static func makeForRegister() -> TodoDetailAndEditViewController {
        let sb = UIStoryboard(name: "TodoDetailAndEdit", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! TodoDetailAndEditViewController
        
        return vc
    }
    
    @objc private func backgroundDidTap() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func headerDidScroll(_ sender: UIPanGestureRecognizer) {
        /// ヘッダービューをスワイプした場合の処理
        /// コールされたと同時にインタラクション開始する。
        interactor.updateStateShouldStartIfNeeded()
        handleTransitionGesture(sender)
    }
    
    //swiが押された時の処理の中身
    @objc func switchStateDidChange(_ sender:UISwitch){
        if sender.isOn {
        } else {
        }
    }
}

extension TodoDetailAndEditViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

/// 以下デリゲートメソッドで、セミモーダルの閉じる処理に関する設定している
extension TodoDetailAndEditViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        ///　セミモーダル遷移時の背景透過アニメーションを行うPresentationControllerを返却
        return ModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        /// dismiss時のアニメーションを定義したクラスを返却
        return DismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        /// インタラクション開始している場合にはinteractorを返却する
        /// 開始していない場合はnilを返却することでインタラクション無しのdissmissとなる
        switch interactor.state {
        case .hasStarted, .shouldFinish:
            return interactor
        case .none, .shouldStart:
            return nil
        }
    }
}

/// RealmSwift
private extension TodoDetailAndEditViewController {
    
    func initRealm() {
        if todoId == 0 {
            return
        }
        realm = try! Realm()
        todoDetail = TodoItem().todoItem(id: todoId)
    }
    
    @objc func tapDelete() {
        let alert: UIAlertController = UIAlertController(title: "areYouAllright".localized, message: nil, preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "ok".localized, style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.deleteTodo()
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "cancel".localized, style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    func deleteTodo() {
        let todoResult = TodoItem().deleteItem(categoryId: categoryId, todoId: todoId)
        // returnでもらった値は使わない
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func create() {
        guard let title = todoTitleTextView.text else {
            showAlert(desc: "titleIsNothing".localized)
            return
        }
        if title.isEmpty {
            showAlert(desc: "titleIsNothing".localized)
            return
        }
        let realm = try! Realm()
        
        // titleから登録したい親カテゴリを抽出
        let category = realm.objects(CategoryItem.self).filter("id = %@", categoryId).first
        
        // todolistのセット 必須項目
        let item = TodoItem()
        item.todoTitle = title
        item.categoryId = self.categoryId
        item.id = item.incrementId()
        // 任意項目
        item.priority = prioritySwitch.isOn
        item.deadlineDate = toDate(dateString: deadlineTextField.text)
        item.memo = memoTextView.text ?? ""
        
        // 登録
        try! realm.write {
            category?.todo.append(item)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func update() {
        
        guard let title = todoTitleTextView.text else {
            showAlert(desc: "titleIsNothing".localized)
            return
        }
        
        if title.isEmpty {
            showAlert(desc: "titleIsNothing".localized)
            return
        }
        
        // todolistのセット 必須項目
        let item = TodoItem()
        item.todoTitle = title
        item.categoryId = self.categoryId
        item.id = todoDetail[0].id
        // 任意項目
        item.priority = prioritySwitch.isOn
        item.deadlineDate = toDate(dateString: deadlineTextField.text)
        item.memo = memoTextView.text ?? ""
        
        // 登録
        item.updateItem(beforeItem: item)
        self.dismiss(animated: true, completion: nil)
    }
    
    //テキストフィールドが選択されたらdatepickerを表示
    @IBAction func textFieldEditing(sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        datePickerView.timeZone = TimeZone.current
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControl.Event.valueChanged)
        
        //datepicker上のtoolbarのdoneボタン
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let clearlItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearBtn))
        let toolBarBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBtn))
        toolBar.items = [clearlItem, toolBarBtn]
        deadlineTextField.inputAccessoryView = toolBar
    }
    
    //datepickerが選択されたらtextfieldに表示
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "yyyy/MM/dd";
        deadlineTextField.text = dateFormatter.string(from: sender.date)
    }
    
    //toolbarのdoneボタン
    @objc func clearBtn(){
        deadlineTextField.text = nil
        deadlineTextField.resignFirstResponder()
    }

    //toolbarのdoneボタン
    @objc func doneBtn(){
        deadlineTextField.resignFirstResponder()
    }
    
    private func showAlert(desc: String) {
        let alert: UIAlertController = UIAlertController(title: "error".localized, message: desc, preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "ok".localized, style: UIAlertAction.Style.default)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func toDate(dateString: String?)-> Date? {
        guard let dateString = dateString else { return nil }
        let dateFormater = DateFormatter()
        dateFormater.timeZone = TimeZone.current
        dateFormater.locale = Locale.current
        dateFormater.dateFormat = "yyyy/MM/dd"
        let date = dateFormater.date(from: dateString)
        // http://tm-b.hatenablog.com/entry/2019/02/12/234518 9時間ずれる問題
        return date
    }
}
