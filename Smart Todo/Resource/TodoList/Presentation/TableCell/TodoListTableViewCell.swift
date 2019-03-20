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
    
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var deadlineView: UIView!
    @IBOutlet weak var deadlineImageView: UIImageView!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var priorityImageView: UIImageView!
    @IBOutlet weak var memoImageView: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var tapView: UIView!
    
    private var todoItem: TodoItem?
    
    let wakaba = UIColor(red: 167/255, green: 219/255, blue: 162/255, alpha: 1.0)
    let koubai = UIColor(red: 235/255, green: 121/255, blue: 136/255, alpha: 1.0)
    let shinbashi = UIColor(red: 116/255, green: 169/255, blue: 214/255, alpha: 1.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let check = UITapGestureRecognizer(target: self, action: #selector(tapCheck(_:)))
        tapView.addGestureRecognizer(check)
        
        deadlineImageView.image = UIImage.fontAwesomeIcon(name: .calendarTimes, style: .solid, textColor: .gray, size: CGSize(width: 15, height: 15))
        memoImageView.image = UIImage.fontAwesomeIcon(name: .pencilAlt, style: .solid, textColor: .gray, size: CGSize(width: 15, height: 15))
        priorityImageView.isHidden = true
        memoImageView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setItem(todoItem: TodoItem?) {
        guard let item = todoItem else { return }
        titleLabel.text = item.todoTitle
        
        if item.doneFlg {
            setDoneDesign()
        } else {
            setCheckDesign()
        }
        titleLabelDecorate(doneFlg: item.doneFlg)
        self.todoItem = item
        
        if let date = item.deadlineDate {
            deadlineView.isHidden = false
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat  = "yyyy/MM/dd";
            deadlineLabel.text = dateFormatter.string(from: date)
        } else {
            deadlineView.isHidden = true
        }
        // todo: 締め日が近ければ赤文字にする
        
        if item.priority {
            priorityImageView.isHidden = false
            priorityImageView.image = UIImage.fontAwesomeIcon(name: .exclamation, style: .solid, textColor: shinbashi, size: CGSize(width: 15, height: 15))
        } else {
            priorityImageView.isHidden = true
        }
        
        memoImageView.isHidden = item.memo.isEmpty
        
        iconView.isHidden = deadlineView.isHidden && priorityImageView.isHidden && memoImageView.isHidden
    }
    
    @IBAction func tapCheck(_: UIGestureRecognizer) {
        guard let item = self.todoItem else { return }
        if item.doneFlg {
            self.setCheckDesign()
            self.tapCheckImage(item: item, flg: false)
        } else {
            self.setDoneDesign()
            self.tapCheckImage(item: item, flg: true)
        }
        self.titleLabelDecorate(doneFlg: item.doneFlg)
    }
    
    func setDoneDesign() {
        checkImageView.image = UIImage(named:"done.png")
        titleLabel.textColor = UIColor.lightGray
    }
    
    func setCheckDesign() {
        titleLabel.textColor = UIColor.black
        checkImageView.image = UIImage(named:"check.png")
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
