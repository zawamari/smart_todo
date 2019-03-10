//
//  CreateCollectionViewCell.swift
//  Smart Todo
//
//  Created by Marie on 2019/03/10.
//  Copyright © 2019 Marie. All rights reserved.
//

import UIKit

class CreateCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var createImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor(red: 188/255, green: 189/255, blue: 194/255, alpha: 1.0).cgColor
        contentView.layer.cornerRadius = 6.0
        contentView.clipsToBounds = true
        
        backView.layer.borderWidth = 0.5
        backView.layer.borderColor = UIColor.gray.cgColor
        backView.layer.cornerRadius = backView.frame.width / 2
        backView.clipsToBounds = true
        
        createImageView.image = UIImage.fontAwesomeIcon(name: .plus, style: .solid, textColor: .gray, size: CGSize(width: 30, height: 30))
    }

}
