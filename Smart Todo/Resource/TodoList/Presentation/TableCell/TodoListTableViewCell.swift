//
//  TodoListTableViewCell.swift
//  Smart Todo
//
//  Created by Marie on 2019/03/05.
//  Copyright © 2019 Marie. All rights reserved.
//

import UIKit
import RealmSwift

protocol TodoListTableViewCellDelegate {
    func tapCheckImage(item: TodoItem, flg: Bool )
}

class TodoListTableViewCell: UITableViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deadlineImageView: UIImageView!
    @IBOutlet weak var deallineLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
    private var todoItem: TodoItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.borderColor = UIColor.gray.cgColor
        backView.layer.borderWidth = 0.5
        backView.layer.cornerRadius = 6.0
        backView.clipsToBounds = true
        
        let check = UITapGestureRecognizer(target: self, action: #selector(tapCheck(_:)))
        checkImageView.addGestureRecognizer(check)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setItem(todoItem: TodoItem?) {
        guard let item = todoItem else { return }
        titleLabel.text = item.todoTitle
        
        if item.doneFlg {
            checkImageView.image = UIImage(named:"done.png")
        } else {
            checkImageView.image = UIImage(named:"check.png")
        }
        self.todoItem = item
        
        // 締め日が近ければ赤文字にする
        // 優先度高のものをマークする
        // チェックしたら最後尾に移動する、画像を切り替える
          // もしくは文字に取り消し線をつける
        
    }
    
    @IBAction func tapCheck(_: UIGestureRecognizer) {
        guard let item = self.todoItem else { return }
        if item.doneFlg {
            checkImageView.image = UIImage(named:"check.png")
            self.tapCheckImage(item: item, flg: false)
        } else {
            checkImageView.image = UIImage(named:"done.png")
            self.tapCheckImage(item: item, flg: true)
        }
        
    }
}
