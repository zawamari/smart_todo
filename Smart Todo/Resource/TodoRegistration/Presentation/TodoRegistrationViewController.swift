//
//  TodoRegistrationViewController.swift
//  Smart Todo
//
//  Created by Marie on 2019/03/06.
//  Copyright © 2019 Marie. All rights reserved.
//

import UIKit

class TodoRegistrationViewController: UIViewController {
    @IBOutlet weak var outsideAreaView: UIView!
    @IBOutlet weak var modalBackgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // initialize
        let outsideAreaViewTap = UITapGestureRecognizer(target: self, action: #selector(tapOutsideArea(_:)))
        outsideAreaView.addGestureRecognizer(outsideAreaViewTap)
        
        outsideAreaView.layer.cornerRadius = 6.0
        outsideAreaView.clipsToBounds = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func tapOutsideArea(_: UIGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension TodoRegistrationViewController {
    static func make() -> TodoRegistrationViewController {
        let storyboard = UIStoryboard(name: "TodoRegistration", bundle: nil)
        return storyboard.instantiateInitialViewController() as! TodoRegistrationViewController
    }
}
