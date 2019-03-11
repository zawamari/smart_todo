//
//  CategoryCreatePopupViewController.swift
//  Smart Todo
//
//  Created by Marie on 2019/03/10.
//  Copyright © 2019 Marie. All rights reserved.
//

import UIKit

class CategoryCreatePopupViewController: UIViewController {
    @IBOutlet weak var modalBackgroundView: UIView!
    @IBOutlet weak var closeImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryTitleTextField: UITextField!
    @IBOutlet weak var colorLabel: UILabel!
    
    @IBOutlet weak var color1ImageView: UIImageView!
    @IBOutlet weak var color2ImageView: UIImageView!
    @IBOutlet weak var color3ImageView: UIImageView!
    @IBOutlet weak var color4ImageView: UIImageView!
    @IBOutlet weak var color5ImageView: UIImageView!
    @IBOutlet weak var color6ImageView: UIImageView!
    @IBOutlet weak var color7ImageView: UIImageView!
    @IBOutlet weak var color8ImageView: UIImageView!
    @IBOutlet weak var color9ImageView: UIImageView!
    @IBOutlet weak var color10ImageView: UIImageView!

    let yellow: UIColor = UIColor(red: 211/255, green: 212/255, blue: 155/255, alpha: 1.0) //淡い黄色
    let araigaki = UIColor(red: 223/255, green: 188/255, blue: 159/255, alpha: 1.0) //洗柿
    let blue = UIColor(red: 183/255, green: 196/255, blue:  22/255, alpha: 1.0) //水色
    let babyPink = UIColor(red: 239/255, green: 193/255, blue: 196/255, alpha: 1.0) //ベビーピンク
    let asamidori = UIColor(red: 162/255, green: 219/255, blue: 168/255, alpha: 1.0) //浅緑
    let usunezu = UIColor(red: 154/255, green: 136/255, blue: 164/255, alpha: 1.0) //薄鼠
    let skyGray = UIColor(red: 188/255, green: 189/255, blue: 194/255, alpha: 1.0) //スカイグレー
    let rikyunezumi = UIColor(red: 114/255, green: 140/255, blue:  12/255, alpha: 1.0) //利休鼠
    let kyarairo = UIColor(red: 224/255, green: 195/255, blue: 132/255, alpha: 1.0) //伽羅色
    let kinari: UIColor = UIColor(red: 208/255, green: 205/255, blue: 184/255, alpha: 1.0) //生成
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        modalBackgroundView.layer.cornerRadius = 6.0
        modalBackgroundView.clipsToBounds = true
        
        // キーボード表示させる
        categoryTitleTextField.becomeFirstResponder()
        
        addGesture()
        
        setColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    /// textfield以外をタップしたらキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        categoryTitleTextField.resignFirstResponder()
    }
    
    func addGesture() {
        let closeImageViewTap = UITapGestureRecognizer(target: self, action: #selector(tapCloseImageView(_:)))
        closeImageView.addGestureRecognizer(closeImageViewTap)
    }
    
    @IBAction func tapCloseImageView(_: UIGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setColor() {
        color1ImageView.image = UIImage.fontAwesomeIcon(name: .circle, style: .solid, textColor: yellow, size: CGSize(width: 30, height: 30))
        color2ImageView.image = UIImage.fontAwesomeIcon(name: .circle, style: .solid, textColor: araigaki, size: CGSize(width: 30, height: 30))
        color3ImageView.image = UIImage.fontAwesomeIcon(name: .circle, style: .solid, textColor: blue, size: CGSize(width: 30, height: 30))
        color4ImageView.image = UIImage.fontAwesomeIcon(name: .circle, style: .solid, textColor: babyPink, size: CGSize(width: 30, height: 30))
        color5ImageView.image = UIImage.fontAwesomeIcon(name: .circle, style: .solid, textColor: asamidori, size: CGSize(width: 30, height: 30))
        color6ImageView.image = UIImage.fontAwesomeIcon(name: .circle, style: .solid, textColor: usunezu, size: CGSize(width: 30, height: 30))
        color7ImageView.image = UIImage.fontAwesomeIcon(name: .circle, style: .solid, textColor: skyGray, size: CGSize(width: 30, height: 30))
        color8ImageView.image = UIImage.fontAwesomeIcon(name: .circle, style: .solid, textColor: rikyunezumi, size: CGSize(width: 30, height: 30))
        color9ImageView.image = UIImage.fontAwesomeIcon(name: .circle, style: .solid, textColor: kyarairo, size: CGSize(width: 30, height: 30))
        color10ImageView.image = UIImage.fontAwesomeIcon(name: .circle, style: .solid, textColor: kinari, size: CGSize(width: 30, height: 30))
    }
}
extension CategoryCreatePopupViewController {
    static func make() -> CategoryCreatePopupViewController {
        let storyboard = UIStoryboard(name: "CategoryCreatePopup", bundle: nil)
        return storyboard.instantiateInitialViewController() as! CategoryCreatePopupViewController
    }
}
