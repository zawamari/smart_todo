//
//  TodoListTableViewCell.swift
//  Smart Todo
//
//  Created by Marie on 2019/03/05.
//  Copyright © 2019 Marie. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListTableViewCell: UITableViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deadlineImageView: UIImageView!
    @IBOutlet weak var deallineLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.borderColor = UIColor.gray.cgColor
        backView.layer.borderWidth = 0.5
        backView.layer.cornerRadius = 6.0
        backView.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setItem(todoItem: TodoItem?) {
        guard let item = todoItem else { return }
        titleLabel.text = item.todoTitle
        
        // 締め日が近ければ赤文字にする
        // 優先度高のものをマークする
        // チェックしたら最後尾に移動する、画像を切り替える
        
    }
    
}
