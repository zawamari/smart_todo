import UIKit

@IBDesignable class PlaceHolderTextView: UITextView {
    // MARK: Properties
    
    /// プレースホルダー
    @IBInspectable var placeHolder: String = "" {
        didSet {
            self.placeHolderLabel.text = self.placeHolder
            self.placeHolderLabel.sizeToFit()
        }
    }
    
    /// [プレースホルダー]ラベル
    private lazy var placeHolderLabel: UILabel = UILabel(frame: CGRect(x: 6.0,
                                                                       y: 6.0,
                                                                       width: 0.0,
                                                                       height: 0.0))
    
    // MARK: Initializers
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configurePlaceHolder()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textChanged),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
    }
    
    override func layoutSubviews() {
        changeVisiblePlaceHolder()
    }
    
    // MARK: Private Methods
    
    /// プレースホルダーを構築する
    private func configurePlaceHolder() {
        self.placeHolderLabel.lineBreakMode = .byWordWrapping
        self.placeHolderLabel.numberOfLines = 0
        self.placeHolderLabel.font = self.font
        self.placeHolderLabel.textColor = UIColor(red: 0.0,
                                                  green: 0.0,
                                                  blue: 0.0980392,
                                                  alpha: 0.22)
        self.placeHolderLabel.backgroundColor = .clear
        self.addSubview(placeHolderLabel)
    }
    
    /// プレースホルダーの表示/非表示を切り替える
    private func changeVisiblePlaceHolder() {
        if self.placeHolder.isEmpty || !self.text.isEmpty {
            self.placeHolderLabel.alpha = 0.0
        } else {
            self.placeHolderLabel.alpha = 1.0
        }
    }
    
    /// テキスト変更
    ///
    /// - Parameter notification: 通知
    @objc private func textChanged(notification: NSNotification?) {
        changeVisiblePlaceHolder()
    }
}
