//
//  TodoDetailAndEditViewController.swift
//  Smart Todo
//
//  Created by Marie on 2019/03/18.
//  Copyright © 2019 Marie. All rights reserved.
//

import UIKit

class TodoDetailAndEditViewController: UIViewController, OverCurrentTransitionable {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var todoDetailView: UIView!
    var percentThreshold: CGFloat = 0.3
    
    var interactor = OverCurrentTransitioningInteractor()
    
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
    }
    
    private func setupViews() {
        headerView.layer.cornerRadius = 12.0
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let headerGesture = UIPanGestureRecognizer(target: self, action: #selector(headerDidScroll(_:)))
        headerView.addGestureRecognizer(headerGesture)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(backgroundDidTap))
        backView.addGestureRecognizer(gesture)
        todoDetailView.addGestureRecognizer(gesture)

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
