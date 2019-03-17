//
//  TodoRegistrationViewController.swift
//  Smart Todo
//
//  Created by Marie on 2019/03/06.
//  Copyright © 2019 Marie. All rights reserved.
//

import UIKit
import RealmSwift

class TodoRegistrationPopupViewController: UIViewController {
    @IBOutlet weak var outsideAreaView: UIView!
    @IBOutlet weak var registerStackView: UIStackView!
    @IBOutlet weak var modalBackgroundView: UIView!
    @IBOutlet weak var createBackgroundLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var priorityView: UIView!
    @IBOutlet weak var prioritySlider: UISlider!
    @IBOutlet weak var priorityLevelLabel: UILabel!
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var deadlineView: UIView!
    @IBOutlet weak var deadlineDateLabel: UILabel!
    @IBOutlet weak var deadlineSwitch: UISwitch!
    @IBOutlet weak var closeImageView: UIImageView!
    
    let wakaba = UIColor(red: 167/255, green: 219/255, blue: 162/255, alpha: 1.0)
    let koubai = UIColor(red: 235/255, green: 121/255, blue: 136/255, alpha: 1.0)
    let shinbashi = UIColor(red: 116/255, green: 169/255, blue: 214/255, alpha: 1.0)
    
    var categoryId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        modalBackgroundView.layer.cornerRadius = 6.0
        modalBackgroundView.clipsToBounds = true
        
        createBackgroundLabel.layer.cornerRadius = 6.0
        createBackgroundLabel.clipsToBounds = true
        
        // キーボード表示させる
        titleTextField.becomeFirstResponder()
        
        addGesture()
        sliderView()
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
    }
    
    func initializedHiddenSetting() {
        detailLabel.isHidden = false
        
        priorityView.isHidden = true
        memoTextField.isHidden = true
        urlTextField.isHidden = true
        deadlineView.isHidden = true
    }
    
    func addGesture() {
        let closeImageViewTap = UITapGestureRecognizer(target: self, action: #selector(tapCloseImageView(_:)))
        closeImageView.addGestureRecognizer(closeImageViewTap)
        
        let detailTap = UITapGestureRecognizer(target: self, action: #selector(tapOpenDetail(_:)))
        detailLabel.addGestureRecognizer(detailTap)
    }
    
    func sliderView() {
        prioritySlider.minimumValue = 1
        prioritySlider.maximumValue = 5
        prioritySlider.tintColor = wakaba
        priorityLabelSetting(level: 3)
        prioritySlider.value = 3 // dataから取得する
        prioritySlider.addTarget(self, action: #selector(sliderChange(sender: )), for: UIControl.Event.valueChanged)
    }
    
    func priorityLabelSetting(level: Int) {
        if level < 3 {
            priorityLevelLabel.textColor = shinbashi
        } else if level == 3 {
            priorityLevelLabel.textColor = wakaba
        } else {
            priorityLevelLabel.textColor = koubai
        }
    }
    
    // スライダー動かした時に実行する処理
    @objc func sliderChange(sender: UISlider){
        priorityLabelSetting(level: Int(sender.value))
        priorityLevelLabel.text = String(Int(sender.value))
    }
    
    @IBAction func tapCloseImageView(_: UIGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapOpenDetail(_: UIGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            self.priorityView.isHidden = false
            self.memoTextField.isHidden = false
            self.urlTextField.isHidden = false
            self.deadlineView.isHidden = false
            self.detailLabel.isHidden = true
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
        
        // todolistのセット
        let emp = TodoItem()
        emp.todoTitle = title
        emp.priority = 3
        emp.categoryId = self.categoryId
        emp.id = emp.incrementId()
        
        // 登録
        try! realm.write {
            category?.todo.append(emp)
        }
        self.dismiss(animated: true, completion: nil)
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
