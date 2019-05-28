import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let contents = [0:"Language".localized]//, 1:"Share".localized, 2:"Review".localized, 3: "Contact".localized ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // NavigationBar Setting
        self.title = "Setting".localized
        
        self.navigationController?.navigationBar.tintColor = .black
        
        let closedImage = UIImage.fontAwesomeIcon(name: .times, style: .solid, textColor: .gray, size: CGSize(width: 25, height: 25))
        let settingButtonItem = UIBarButtonItem(image: closedImage, style: .plain, target: self, action: #selector(didTapClosed))
        self.navigationItem.leftBarButtonItem = settingButtonItem
    }
    
    @objc func didTapClosed() {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)
        cell.textLabel!.text = contents[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            showLanguageSettingAlert()
        case 1:
            print("1")
        default:
            print("default")
        }
    }
}

extension SettingViewController {
    static func make() -> SettingViewController {
        let sb = UIStoryboard(name: "Setting", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! SettingViewController
        return vc
    }
    
    func showLanguageSettingAlert() {
        let alert = UIAlertController(title: "Language".localized, message: "LanguageMessage".localized, preferredStyle:  UIAlertController.Style.actionSheet)
        
        // Defaultボタン
        let defaultAction_1: UIAlertAction = UIAlertAction(title: "English".localized, style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            self.registerLanguage(language: "English")
        })
        let defaultAction_2 = UIAlertAction(title: "Japanese".localized, style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            self.registerLanguage(language: "Japanese")
        })
        
        let defaultAction_3 = UIAlertAction(title: "Korean".localized, style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            self.registerLanguage(language: "Korean")
        })
        
        let defaultAction_4 = UIAlertAction(title: "Chinese".localized, style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            self.registerLanguage(language: "Chinese")
        })

        // Cancelボタン
        let cancelAction = UIAlertAction(title: "cancel".localized, style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
        })
        
        alert.addAction(defaultAction_1)
        alert.addAction(defaultAction_2)
        alert.addAction(defaultAction_3)
        alert.addAction(defaultAction_4)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func registerLanguage(language: String) {
        let userDefault = UserDefaults.standard
        
        userDefault.set(language, forKey: "language")
    }
}
