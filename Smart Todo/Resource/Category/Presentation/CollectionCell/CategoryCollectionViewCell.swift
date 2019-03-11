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
    @IBOutlet weak var tasksLabel: UILabel!
    let skygray = UIColor(red: 188/255, green: 189/255, blue: 194/255, alpha: 1.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor(red: 188/255, green: 189/255, blue: 194/255, alpha: 1.0).cgColor
        contentView.layer.cornerRadius = 6.0
        contentView.clipsToBounds = true
        
        categoryNameLabel.textColor = UIColor.black
        tasksLabel.textColor = UIColor.lightGray
    }
}

extension CategoryCollectionViewCell {
    func setupCell(name: String, tasks: Int? ) {
        categoryNameLabel.text = name
        if let count = tasks {
            tasksLabel.text = String(count) + " tasks"
            categoryIconImageView.image = UIImage.fontAwesomeIcon(name: .circle, style: .solid, textColor: skygray, size: CGSize(width: 20, height: 20))
        }
    }
}
