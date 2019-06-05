//
//  TodoNoneTableViewCell.swift
//  Smart Todo
//
//  Created by Marie on 2019/03/20.
//  Copyright © 2019 Marie. All rights reserved.
//

import UIKit

class TodoNoneTableViewCell: UITableViewCell {

    @IBOutlet weak var itemIsNothingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        itemIsNothingLabel.text = "itemIsNothing".localized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
