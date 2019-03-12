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

        contentView.layer.cornerRadius = 6.0
        contentView.clipsToBounds = true
        
        createImageView.image = UIImage.fontAwesomeIcon(name: .plus, style: .solid, textColor: .gray, size: CGSize(width: 30, height: 30))
    }

}
