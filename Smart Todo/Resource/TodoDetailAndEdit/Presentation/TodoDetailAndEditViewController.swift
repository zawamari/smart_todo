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
    @IBOutlet weak var todoTitleView: UIView!
    @IBOutlet weak var todoTitleTextView: UITextView!

    @IBOutlet weak var priorityImageView: UIImageView!
    @IBOutlet weak var priorityLevelLabel: UILabel!
     @IBOutlet weak var deadlineImageView: UIImageView!
    @IBOutlet weak var deadlineLabel: UILabel!

    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var urlTextView: UITextView!
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var deleteLabel: UILabel!
    var percentThreshold: CGFloat = 0.3
    
    var interactor = OverCurrentTransitioningInteractor()
    
    private var realm: Realm!
    var categoryId: Int = 0
    var todoId = 0
    private var todoDetail: Results<TodoItem>!
    
    let araigaki = UIColor(red: 223/255, green: 188/255, blue: 159/255, alpha: 1.0) //洗柿
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        initializedView()
    }
    
    /// textfield以外をタップしたらキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        todoTitleTextView.resignFirstResponder()
        urlTextView.resignFirstResponder()
        memoTextView.resignFirstResponder()
    }
    
    private func setupViews() {
        todoDetailView.layer.cornerRadius = 12.0
        todoDetailView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let headerGesture = UIPanGestureRecognizer(target: self, action: #selector(headerDidScroll(_:)))
        todoDetailView.addGestureRecognizer(headerGesture)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(backgroundDidTap))
        backView.addGestureRecognizer(gesture)

    }
    
    private func initializedView() {
        draggerImageView.image = UIImage.fontAwesomeIcon(name: .caretDown, style: .solid, textColor: .gray, size: CGSize(width: 60, height: 5))
        todoTitleTextView.text = todoDetail[0].todoTitle
        priorityLevelLabel.text = String(todoDetail[0].priority)
        priorityImageView.image = UIImage.fontAwesomeIcon(name: .exclamation, style: .solid, textColor: .gray, size: CGSize(width: 30, height: 30))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        if let date = todoDetail[0].deadlineDate {
            deadlineLabel.text = formatter.string(from: date)

        }
        memoTextView.text = todoDetail[0].memo
        memoTextView.layer.cornerRadius = 5.0
        
        urlTextView.text = todoDetail[0].url
        urlTextView.layer.cornerRadius = 5.0
        
        deadlineImageView.image = UIImage.fontAwesomeIcon(name: .calendarTimes, style: .solid, textColor: .gray, size: CGSize(width: 30, height: 30))
        deleteLabel.layer.cornerRadius = 5.0
        deleteLabel.layer.masksToBounds = true
        deleteLabel.textColor = araigaki
        
        updateLabel.layer.cornerRadius = 5.0
        updateLabel.layer.masksToBounds = true

    }
    
    static func make() -> TodoDetailAndEditViewController {
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
        realm = try! Realm()
        todoDetail = TodoItem().todoItem(id: todoId)
    }
    
    func deleteCategoryItem(at index: Int) {
//        todoList = TodoItem().deleteItem(categoryId: categoryId, todoId: todoList[index].id)
    }
}
