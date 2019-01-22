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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testLabel.text = "Hi! Marie!"
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
