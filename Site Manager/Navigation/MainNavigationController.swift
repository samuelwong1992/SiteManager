//
//  MainNavigationController.swift
//  Site Manager
//
//  Created by Samuel Wong on 9/2/21.
//

import UIKit

protocol MainNavigationControllerDelegate {
    func didClose(forMainNavigationController mainNavigationController: MainNavigationController)
}

class MainNavigationController: UINavigationController {
    var mainNavBar: MainNavBar!
    
    var _delegate: MainNavigationControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        if let mainNavBar = mainNavBar {
            mainNavBar.frame = self.navigationBar.frame.addingSize(width: 0, height: self.view.safeAreaInsets.top)
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func initialize() {
        performInitialize()
    }
}

//MARK: Initialization
extension MainNavigationController {
    func performInitialize() {
        mainNavBar = MainNavBar(frame: self.navigationBar.frame)
        mainNavBar._delegate = self
        self.view.addSubview(mainNavBar)
        
        self.navigationBar.isTranslucent = false
        self.edgesForExtendedLayout = []
    }
}

//MARK: Helpers
extension MainNavigationController {
    func setTitle(title: String) {
        self.mainNavBar.titleLabel.text = title
    }
}

//MARK: Nav Bar Delegate
extension MainNavigationController: MainNavBarDelegate {    
    func shouldClose(forMainNavBar mainNavBar: MainNavBar) {
        self.popViewController(animated: true)
        self.dismiss(animated: true, completion: {
            self._delegate?.didClose(forMainNavigationController: self)
        })
    }
}
