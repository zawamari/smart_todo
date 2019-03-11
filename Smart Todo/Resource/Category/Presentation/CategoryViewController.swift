//
//  CategoryViewController.swift
//  Smart Todo
//
//  Created by Marie on 2019/01/15.
//  Copyright © 2019 Marie. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UIViewController {

    private var realm: Realm!
    private let category: CategoryItem = CategoryItem()
    private var categoryList: Results<CategoryItem>!
    private var token: NotificationToken!
    private var categoryCount: Int = 0
    
    private var todoList: Results<TodoItem>!
    private var todoToken: NotificationToken!
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var categorycollectionView: UICollectionView!
    
    var window: UIWindow?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        allCategory()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBar Setting
        self.title = "Category"
        
        let createButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(clickCreateCategoryButton))
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.setRightBarButtonItems([createButton], animated: true)

        // Comment Setting
        testLabel.text = "Let's clean up the task"
        
        // CollectionView Setting
        categorycollectionView.dataSource = self
        categorycollectionView.delegate = self
        
        let itemSize = UIScreen.main.bounds.width / 2 - 30
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 20
        
        categorycollectionView.collectionViewLayout = layout
        
        categorycollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
        // collectionview cellに長押しのアクションを追加する
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressAction))
        longPressRecognizer.allowableMovement = 10
        longPressRecognizer.minimumPressDuration = 0.5
        categorycollectionView.addGestureRecognizer(longPressRecognizer)
    }
    
    func reload() {
        categorycollectionView.reloadData()
    }
}

extension CategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath)
        
        if let cell = cell as? CategoryCollectionViewCell { //todo nest
            if indexPath.row == 0 {
                cell.setupCell(name: "ALL", tasks: TodoItem().allCount())
                return cell
            }

            if let title = categoryList?[indexPath.row].categoryTitle ,
                let categoryId = categoryList?[indexPath.row].id {
                cell.setupCell(name: title, tasks: TodoItem().categoryItemCount(categoryId: categoryId))
            }
        }
        // 影をつける
        cell.layer.masksToBounds = false
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowColor = UIColor(red: 188/255, green: 189/255, blue: 194/255, alpha: 1.0).cgColor
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TodoListTableViewController()
        vc.navigationTitle = categoryList?[indexPath.row].categoryTitle
        if let cid = categoryList?[indexPath.row].id {
            vc.categoryId = cid
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension CategoryViewController {
    static func make() -> CategoryViewController {
        let storyboard = UIStoryboard(name: "Category", bundle: nil)
        return storyboard.instantiateInitialViewController() as! CategoryViewController
    }
}

private extension CategoryViewController {
    /// Create New Category Action
    @objc func clickCreateCategoryButton(){

        // popupで登録するときは以下のコメントを実行する
//        let categoryCreatePopupViewController = CategoryCreatePopupViewController.make()
//
//        let nav = UINavigationController(rootViewController: categoryCreatePopupViewController)
//        nav.modalTransitionStyle = .crossDissolve
//        nav.modalPresentationStyle = .overFullScreen
//        self.present(nav, animated: true, completion: nil)
        
        let alert: UIAlertController = UIAlertController(title: "Category Create", message: "What is new category name?", preferredStyle:  UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: nil)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
            if let t = alert.textFields![0].text, !t.isEmpty {
                self.addCategoryItem(title: t)
            }
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    // Delete Category Action
    @objc func onLongPressAction(sender: UILongPressGestureRecognizer) {
        let point: CGPoint = sender.location(in: self.categorycollectionView)
        let indexPath = self.categorycollectionView.indexPathForItem(at: point)
        
        if let indexPath = indexPath {
            switch sender.state {
            case .began:
                break
            case .ended:
                showMenu(index: indexPath.item)
            default:
                break
            }
        }
    }
}

private extension CategoryViewController {
    
    func showMenu(index: Int) {
        if index == 0 { return } /// allCategoryは操作できない
        let alertSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let action1 = UIAlertAction(title: "EDIT", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            self.categoryEdit(index: index)
        })
        let action2 = UIAlertAction(title: "DELETE", style: UIAlertAction.Style.destructive, handler: {
            (action: UIAlertAction!) -> Void in
            self.categoryDelete(index: index)
        })
        let action3 = UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.cancel, handler: {
            (action: UIAlertAction!) in
        })
        
        alertSheet.addAction(action1)
        alertSheet.addAction(action2)
        alertSheet.addAction(action3)
        
        self.present(alertSheet, animated: true, completion: nil)
    }

    func categoryEdit(index: Int) {
        let categoryId = self.categoryList[index].id
        let title = self.categoryList[index].categoryTitle
        
        showEditAlert(id: categoryId, title: title, beforeItem: self.categoryList[index])
    }
    
    func showEditAlert(id: Int, title: String, beforeItem: CategoryItem) {
        let alert: UIAlertController = UIAlertController(title: "Category Edit", message: nil, preferredStyle:  UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: { (textField:UITextField) -> Void in
            textField.text = title
        })
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            if let t = alert.textFields![0].text, !t.isEmpty {
                self.category.edit(id: id, title: t, beforeItem: beforeItem)
            }
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)

    }

    /// deleteを選んだら、itemが0だったらそのまま削除して、itemがあればアラートを表示して全て消えるけど削除するか聞く
    func categoryDelete(index: Int) {
        if 0 < TodoItem().categoryItemCount(categoryId: categoryList[index].id) {
            showAttentionAlert(index: index)
        } else {
            category.delete(category: categoryList[index])
        }
    }

    func showAttentionAlert(index: Int) {
        let alert: UIAlertController = UIAlertController(title: "Are you allright?", message: "This category have some items.", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            TodoItem().deleteItemInCategory(categoryId: self.categoryList[index].id)
            self.category.delete(category: self.categoryList[index])
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
}

/// RealmSwift
private extension CategoryViewController {
    func allCategory() {
        // RealmのTodoリストを取得し，更新を監視
        categoryList = category.categories()
        token = categoryList.observe { [weak self] _ in
            self?.reload()
        }
        categoryCount = categoryList.count
    }
    
    func addCategoryItem(title: String) {
        category.register(title: title, priority: false)
    }
    
    func deleteCategoryItem(at index: Int) {
        category.delete(category: categoryList[index])
    }
}
