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
    
    let colors = [UIColor(red: 211/255, green: 212/255, blue: 155/255, alpha: 1.0), //淡い黄色
                  UIColor(red: 223/255, green: 188/255, blue: 159/255, alpha: 1.0), //洗柿
                  UIColor(red: 183/255, green: 196/255, blue:  22/255, alpha: 1.0), //水色
                  UIColor(red: 239/255, green: 193/255, blue: 196/255, alpha: 1.0), //ベビーピンク
                  UIColor(red: 162/255, green: 219/255, blue: 168/255, alpha: 1.0), //浅緑
                  UIColor(red: 154/255, green: 136/255, blue: 164/255, alpha: 1.0), //薄鼠
                  UIColor(red: 188/255, green: 189/255, blue: 194/255, alpha: 1.0), //スカイグレー
                  UIColor(red: 114/255, green: 140/255, blue:  12/255, alpha: 1.0), //利休鼠
                  UIColor(red: 224/255, green: 195/255, blue: 132/255, alpha: 1.0), //伽羅色
                  UIColor(red: 208/255, green: 205/255, blue: 184/255, alpha: 1.0) //生成
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.borderWidth = 3.0
        contentView.layer.borderColor = UIColor(red: 188/255, green: 189/255, blue: 194/255, alpha: 1.0).cgColor
        contentView.layer.cornerRadius = 6.0
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
        taskColorView.layer.backgroundColor = colors[tasks].cgColor
    }
}
