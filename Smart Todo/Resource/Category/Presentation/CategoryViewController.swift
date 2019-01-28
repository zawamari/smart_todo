//
//  CategoryViewController.swift
//  Smart Todo
//
//  Created by Marie on 2019/01/15.
//  Copyright © 2019 Marie. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var categorycollectionView: UICollectionView!
    
    let testModel = ["Work", "Buy", "2019 year Goal", "Hawaii", "Nursery school", "Hobby", "Team", "Personal", "Family", "Change" ]
    
    var window: UIWindow?
    
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
    }
    
    /// Create New Category
    @objc func clickCreateCategoryButton(){
        let alert: UIAlertController = UIAlertController(title: "Category Create?", message: "What is new category name?", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath)
        
        if let cell = cell as? CategoryCollectionViewCell {
            cell.setupCell(name: testModel[indexPath.row], tasks: indexPath.row)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("******\(indexPath)")
    }
}

extension CategoryViewController {
    static func make() -> CategoryViewController {
        let storyboard = UIStoryboard(name: "Category", bundle: nil)
        return storyboard.instantiateInitialViewController() as! CategoryViewController
    }
}
