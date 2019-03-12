//
//  CreateTableViewCell.swift
//  Smart Todo
//
//  Created by Marie on 2019/03/11.
//  Copyright © 2019 Marie. All rights reserved.
//

import UIKit
import FontAwesome_swift

class CreateTableViewCell: UITableViewCell {

    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        addImageView.image = UIImage.fontAwesomeIcon(name: .plus, style: .solid, textColor: .gray, size: CGSize(width: 20, height: 20))
        addImageView.clipsToBounds = true
        
        backView.layer.borderColor = UIColor.gray.cgColor
        backView.layer.borderWidth = 0.5
        backView.layer.cornerRadius = 6.0
        backView.clipsToBounds = true
        // 影をつける
//        backView.layer.cornerRadius = 10.0
//        backView.layer.masksToBounds = false
//        backView.layer.shadowColor = UIColor.black.cgColor
//        backView.layer.shadowOpacity = 0.25
//        backView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        backView.layer.shadowRadius = 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
