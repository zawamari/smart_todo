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
        addImageView.image = UIImage.fontAwesomeIcon(name: .plus, style: .solid, textColor: .gray, size: CGSize(width: 30, height: 30))
        addImageView.clipsToBounds = false
        
        backView.layer.borderColor = UIColor.gray.cgColor
        backView.layer.borderWidth = 0.5
        backView.layer.cornerRadius = 6.0
        backView.clipsToBounds = true
        // 影をつける
        backView.layer.masksToBounds = false
        backView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        backView.layer.shadowOpacity = 1.0
        backView.layer.shadowRadius = 2.0
        backView.layer.shadowColor = UIColor(red: 188/255, green: 189/255, blue: 194/255, alpha: 1.0).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
