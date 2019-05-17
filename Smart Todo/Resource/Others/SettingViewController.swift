import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let contents = [0:"laungage", 1:"share", 2:"review", 3: "お問い合わせ" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // NavigationBar Setting
        self.title = "Setting"
        
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
            print("0")
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
}
