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
    override func awakeFromNib() {
        super.awakeFromNib()
        addImageView.image = UIImage.fontAwesomeIcon(name: .plus, style: .solid, textColor: .gray, size: CGSize(width: 30, height: 30))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
