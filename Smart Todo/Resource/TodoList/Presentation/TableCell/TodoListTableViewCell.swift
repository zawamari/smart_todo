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
//    @IBOutlet weak var deadlineImageView: UIImageView!
//    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var tapView: UIView!
    
    private var todoItem: TodoItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        backView.layer.cornerRadius = 6.0
        backView.clipsToBounds = true
        
        // 影をつける
        backView.layer.masksToBounds = false
        backView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        backView.layer.shadowOpacity = 1.0
        backView.layer.shadowRadius = 2.0
        backView.layer.shadowColor = UIColor(red: 188/255, green: 189/255, blue: 194/255, alpha: 1.0).cgColor
        
        let check = UITapGestureRecognizer(target: self, action: #selector(tapCheck(_:)))
        tapView.addGestureRecognizer(check)
        
//        deadlineImageView.isHidden = true
//        deadlineLabel.isHidden = true
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
        titleLabelDecorate(doneFlg: item.doneFlg)
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
        self.titleLabelDecorate(doneFlg: item.doneFlg)
    }
    
    func titleLabelDecorate(doneFlg: Bool) {
        guard let titleText = titleLabel.text else { return }
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: titleText)

        if doneFlg {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        }
        self.titleLabel.attributedText = attributeString
    }
}
