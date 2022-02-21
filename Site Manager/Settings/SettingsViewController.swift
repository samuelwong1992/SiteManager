//
//  SettingsViewController.swift
//  Site Manager
//
//  Created by Samuel Wong on 11/2/2022.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var profileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    func initialize() {
        profileButton.addTarget(self, action: #selector(profileButton_didPress), for: .touchUpInside)
    }
}

//MARK: Button Handlers
@objc extension SettingsViewController {
    func profileButton_didPress() {
        if let vc = ProfileViewController.viewController {
            self.present(vc, animated: true, completion: nil)
        }
    }
}
