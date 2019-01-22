//
//  CategoryCollectionViewCell.swift
//  Smart Todo
//
//  Created by Marie on 2019/01/14.
//  Copyright © 2019 Marie. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var tasksLabel: UILabel!
    @IBOutlet weak var taskColorView: UIView!
    
    let colors = [UIColor.red.cgColor, UIColor.blue.cgColor, UIColor.purple.cgColor, UIColor.green.cgColor, UIColor.yellow.cgColor, UIColor.gray.cgColor, UIColor.darkGray.cgColor, UIColor.yellow.cgColor, UIColor.darkGray.cgColor, UIColor.orange.cgColor]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.borderWidth = 3.0
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.cornerRadius = 4.0
        contentView.clipsToBounds = true
        
        categoryNameLabel.textColor = UIColor.black
        tasksLabel.textColor = UIColor.lightGray
        
        taskColorView.layer.cornerRadius = taskColorView.bounds.width / 2
    }
}

extension CategoryCollectionViewCell {
    func setupCell(name: String, tasks: Int ) {
        categoryNameLabel.text = name
        tasksLabel.text = String(tasks) + " tasks"
        taskColorView.layer.backgroundColor = colors[tasks]
    }
}
