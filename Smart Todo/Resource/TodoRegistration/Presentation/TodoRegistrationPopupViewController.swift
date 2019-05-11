//
//  TodoRegistrationViewController.swift
//  Smart Todo
//
//  Created by Marie on 2019/03/06.
//  Copyright © 2019 Marie. All rights reserved.
//

import UIKit
import RealmSwift

class TodoRegistrationPopupViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var outsideAreaView: UIView!
    @IBOutlet weak var registerStackView: UIStackView!
    @IBOutlet weak var modalBackgroundView: UIView!

    @IBOutlet weak var createBackgroundLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailLabel: UILabel!

    @IBOutlet weak var priorityView: UIView!
    @IBOutlet weak var priorityImageView: UIImageView!
    @IBOutlet weak var prioritySwitch: UISwitch!

    @IBOutlet weak var urlTextField: UITextField!

    @IBOutlet weak var deadlineView: UIView!
    @IBOutlet weak var deadlineImageView: UIImageView!
    @IBOutlet weak var deadlineTextField: UITextField!

    @IBOutlet weak var memoView: UIView!
    @IBOutlet weak var memoImageView: UIImageView!
    @IBOutlet weak var memoTextField: UITextField!

    @IBOutlet weak var closeImageView: UIImageView!

    let wakaba = UIColor(red: 167/255, green: 219/255, blue: 162/255, alpha: 1.0)
    let koubai = UIColor(red: 235/255, green: 121/255, blue: 136/255, alpha: 1.0)
    let shinbashi = UIColor(red: 116/255, green: 169/255, blue: 214/255, alpha: 1.0)
    
    var categoryId: Int = 0
    var datePicker: UIDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)

        self.titleTextField.delegate = self
        self.memoTextField.delegate = self
        self.urlTextField.delegate = self
        self.deadlineTextField.delegate = self
        initialized()
        addGesture()
        initializedHiddenSetting()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    /// textfield以外をタップしたらキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleTextField.resignFirstResponder()
        memoTextField.resignFirstResponder()
        urlTextField.resignFirstResponder()
        deadlineTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        memoTextField.resignFirstResponder()
        urlTextField.resignFirstResponder()
        deadlineTextField.resignFirstResponder()
        return true
    }
    
    func initialized() {
        modalBackgroundView.layer.cornerRadius = 6.0
        modalBackgroundView.clipsToBounds = true
        
        createBackgroundLabel.layer.cornerRadius = 6.0
        createBackgroundLabel.clipsToBounds = true
        
        // キーボード表示させる
        titleTextField.becomeFirstResponder()
        
        titleTextField.attributedPlaceholder = NSAttributedString(string: "todo title", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        memoTextField.attributedPlaceholder = NSAttributedString(string: "memo", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        urlTextField.attributedPlaceholder = NSAttributedString(string: "https://xxxx.co", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        deadlineTextField.attributedPlaceholder = NSAttributedString(string: getToday(), attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        prioritySwitch.isOn = false
        
        priorityImageView.image =  UIImage.fontAwesomeIcon(name: .star, style: .solid, textColor: .gray, size: CGSize(width: 25, height: 25))
        deadlineImageView.image = UIImage.fontAwesomeIcon(name: .calendarTimes, style: .solid, textColor: .gray, size: CGSize(width: 25, height: 25))
        memoImageView.image =  UIImage.fontAwesomeIcon(name: .pen, style: .solid, textColor: .gray, size: CGSize(width: 25, height: 25))
    }
    
    func initializedHiddenSetting() {
        detailLabel.isHidden = false
        
        priorityView.isHidden = true
        urlTextField.isHidden = true
        deadlineView.isHidden = true
        memoView.isHidden = true
        memoTextField.isHidden = true
    }

    func addGesture() {
        let closeImageViewTap = UITapGestureRecognizer(target: self, action: #selector(tapCloseImageView(_:)))
        closeImageView.addGestureRecognizer(closeImageViewTap)
        
        let detailTap = UITapGestureRecognizer(target: self, action: #selector(tapOpenDetail(_:)))
        detailLabel.addGestureRecognizer(detailTap)
        
        deadlineTextField.addTarget(self, action: #selector(textFieldEditing(sender: )), for: UIControl.Event.allEvents)
        
        prioritySwitch.addTarget(self, action: #selector(switchStateDidChange(_:)), for: .valueChanged)
        
    }

    func getToday(format:String = "yyyy/MM/dd") -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
        return formatter.string(from: now as Date)
    }
    
    //swiが押された時の処理の中身
    @objc func switchStateDidChange(_ sender:UISwitch){
        if sender.isOn {
        } else {
        }
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

    //modalを閉じる
    @IBAction func tapCloseImageView(_: UIGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapOpenDetail(_: UIGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            self.priorityView.isHidden = false
            self.memoTextField.isHidden = false
//            self.urlTextField.isHidden = true // Todo: URLは次のリリースの時にでも。。
            self.deadlineView.isHidden = false
            self.detailLabel.isHidden = true
            self.memoView.isHidden = false
            self.registerStackView.layoutIfNeeded()
        }
    }
    
    @IBAction func tapCreateButton(_ sender: Any) {
        register()
    }
}

extension TodoRegistrationPopupViewController {
    static func make() -> TodoRegistrationPopupViewController {
        let storyboard = UIStoryboard(name: "TodoRegistrationPopup", bundle: nil)
        return storyboard.instantiateInitialViewController() as! TodoRegistrationPopupViewController
    }
}

extension TodoRegistrationPopupViewController {
    private func register() {
        guard let _ = validation() else {
            // できればアラート出す
            return
        }
        
        guard let title = titleTextField.text else {
            showAlert(desc: "title is nothing")
            return
        }
        
        if title.isEmpty {
            showAlert(desc: "title is nothing")
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
        item.memo = memoTextField.text ?? ""
//        item.url = urlTextField.text ?? ""

        // 登録
        try! realm.write {
            category?.todo.append(item)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func toDate(dateString: String?)-> Date? {
        guard let dateString = dateString else { return nil }
        let dateFormater = DateFormatter()
        dateFormater.timeZone = TimeZone.current
        dateFormater.locale = Locale.current
        dateFormater.dateFormat = "yyyy/MM/dd"
        let date = dateFormater.date(from: dateString)
        // http://tm-b.hatenablog.com/entry/2019/02/12/234518 9時間ずれる問題
        return date
    }
    
    private func validation() -> Bool? {
        // 同じtitleないか
        return true
    }
}

extension TodoRegistrationPopupViewController {
    private func showAlert(desc: String) {
        let alert: UIAlertController = UIAlertController(title: "Error!", message: desc, preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
