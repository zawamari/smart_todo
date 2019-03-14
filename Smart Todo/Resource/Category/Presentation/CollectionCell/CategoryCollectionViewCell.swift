//
//  CategoryCollectionViewCell.swift
//  Smart Todo
//
//  Created by Marie on 2019/01/14.
//  Copyright © 2019 Marie. All rights reserved.
//

import UIKit
import FontAwesome_swift

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryIconImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var allTasksImageView: UIImageView!
    @IBOutlet weak var allTasksCountLabel: UILabel!
    @IBOutlet weak var doneTasksImageView: UIImageView!
    @IBOutlet weak var doneTasksLabel: UILabel!
    let skygray = UIColor(red: 188/255, green: 189/255, blue: 194/255, alpha: 1.0)
    let kanariya = UIColor(red: 224/255, green: 234/255, blue: 58/255, alpha: 1.0)
    let wakaba = UIColor(red: 167/255, green: 219/255, blue: 162/255, alpha: 1.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 6.0
        contentView.clipsToBounds = true
        categoryIconImageView.layer.masksToBounds = true
        
        categoryNameLabel.textColor = UIColor.black
        doneTasksLabel.textColor = UIColor.lightGray
        allTasksCountLabel.textColor = UIColor.lightGray
    }
}

extension CategoryCollectionViewCell {
    func setupCell(name: String, tasks: Int?, doneTasks: Int?) {
        categoryNameLabel.text = name
        
        allTasksImageView.image = UIImage.fontAwesomeIcon(name: .circle, style: .solid, textColor: kanariya, size: CGSize(width: 10, height: 10))
        if let count = tasks {
            allTasksCountLabel.text = String(count)
        }
        
        doneTasksImageView.image = UIImage.fontAwesomeIcon(name: .check, style: .solid, textColor: wakaba, size: CGSize(width: 10, height: 10))
        if let count = doneTasks {
            doneTasksLabel.text = String(count)
            
        }
        
        //categoryIconImageView.image = UIImage.fontAwesomeIcon(name: .circle, style: .solid, textColor: skygray, size: CGSize(width: 20, height: 20)) // いまは一旦消しとく

    }
}
