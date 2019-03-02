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
    private var categoryList: Results<CategoryItem>!
    private var token: NotificationToken!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var categorycollectionView: UICollectionView!
    
    var window: UIWindow?
    
    override func awakeFromNib() {//  todo listから戻ってきたときにtask数が更新されてるか？viewWillAppearの方が良い？
        super.awakeFromNib()
        // RealmのTodoリストを取得し，更新を監視
        realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        categoryList = realm.objects(CategoryItem.self).sorted(byKeyPath: "createdAt", ascending: true) // true-> 作成日古い順
        token = categoryList.observe { [weak self] _ in
            self?.reload()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBar Setting
        self.title = "Category"
        
        let createButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(clickCreateCategoryButton))
        
        self.navigationItem.setRightBarButtonItems([createButton], animated: true)

        // Comment Setting
        testLabel.text = "Hi! Marie!"
        
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
    
    /// Create New Category
    @objc func clickCreateCategoryButton(){
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
}

extension CategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath)
        
        if let cell = cell as? CategoryCollectionViewCell {
            if let title = categoryList?[indexPath.row].categoryTitle {
                cell.setupCell(name: title, tasks: indexPath.row)
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TodoListTableViewController()
        vc.navigationTitle = categoryList?[indexPath.row].categoryTitle
        vc.categoryId = 0
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
    func addCategoryItem(title: String) {
        try! realm.write {
            realm.add(CategoryItem(value: ["categoryTitle": title]))
        }
    }
    
    func deleteCategoryItem(at index: Int) {
        try! realm.write {
            realm.delete(categoryList[index])
        }
    }
    
    @objc func onLongPressAction(sender: UILongPressGestureRecognizer) {
        let point: CGPoint = sender.location(in: self.categorycollectionView)
        let indexPath = self.categorycollectionView.indexPathForItem(at: point)
        
        if let indexPath = indexPath {
            switch sender.state {
            case .began:
                break
            case .ended:
                deleteCategoryItem(at: indexPath.item)
            default:
                break
            }
        }
    }
}
