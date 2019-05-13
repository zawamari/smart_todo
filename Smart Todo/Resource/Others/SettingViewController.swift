import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // NavigationBar Setting
        self.title = "Setting"
        
        self.navigationController?.navigationBar.tintColor = .black
        
        let closedImage = UIImage.fontAwesomeIcon(name: .cross, style: .solid, textColor: .gray, size: CGSize(width: 25, height: 25))
        let settingButtonItem = UIBarButtonItem(image: closedImage, style: .plain, target: self, action: #selector(didTapClosed))
        self.navigationItem.leftBarButtonItem = settingButtonItem
    }
    
    @objc func didTapClosed() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension SettingViewController {
    static func make() -> SettingViewController {
        let sb = UIStoryboard(name: "Setting", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! SettingViewController
        return vc
    }
}
