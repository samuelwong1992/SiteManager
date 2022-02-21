//
//  MainTabBarController.swift
//  Site Manager
//
//  Created by Samuel Wong on 4/2/21.
//

import UIKit

class MainTabBarController: UITabBarController {

    var mainTabBar: MainTabBar!
    
    private var _viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if ProfileHelpers.profile == nil {
            if let vc = ProfileViewController.viewController {
                vc.isModalInPresentation = true
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        if let mainTabBar = mainTabBar {
            mainTabBar.removeFromSuperview()
            for constraint in mainTabBar.constraints {
                constraint.isActive = false
            }
            self.view.addSubViewToBottom(subview: mainTabBar, withHeight: tabBar.frame.size.height + self.view.safeAreaInsets.bottom +  1)
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

//MARK: Initialization
extension MainTabBarController {
    func initialize() {
        mainTabBar = MainTabBar(frame: tabBar.frame)
        mainTabBar._delegate = self
        self.view.addSubViewToBottom(subview: mainTabBar, withHeight: tabBar.frame.size.height)
        
        _viewControllers = []
        
        for tabBarButton in TabBarButton.TabBarButtonTypes.allCases {
            if let initialViewController = tabBarButton.storyboard.instantiateInitialViewController() {
                _viewControllers.append(initialViewController)
            }
        }
        
        self.viewControllers = _viewControllers
    }
}

//MARK: Tab Bar Delegate
extension MainTabBarController: MainTabBarDelegate {
    func mainTabBar(mainTabBar: MainTabBar, didSelectTabBarButton tabBarButton: TabBarButton.TabBarButtonTypes) {
        self.selectedIndex = tabBarButton.rawValue
    }
}

