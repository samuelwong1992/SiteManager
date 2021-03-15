//
//  ProjectTabBarController.swift
//  Site Manager
//
//  Created by Samuel Wong on 9/2/21.
//

import UIKit

class ProjectTabBarController: UITabBarController {
    
    var projectTabBar: ProjectTabBar!
    
    var _viewControllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        if let projectTabBar = projectTabBar {
            projectTabBar.frame = tabBar.frame.offsetBy(dx: 0, dy: -self.view.safeAreaInsets.bottom - 1).addingSize(width: 0, height: self.view.safeAreaInsets.bottom +  1)
        }
    }
}

//MARK: Initialization
extension ProjectTabBarController {
    func initialize() {
        projectTabBar = ProjectTabBar(frame: tabBar.frame)
        projectTabBar._delegate = self
        self.view.addSubViewToBottom(subview: projectTabBar, withHeight: projectTabBar.frame.height)
        self.view.bringSubviewToFront(projectTabBar)
        self.tabBar.alpha = 0.1
        
        _viewControllers = []
        
        for tabBarButton in ProjectTabBarButton.TabBarButtonTypes.allCases {
            let vc = tabBarButton.viewController
            if let navController = self.navigationController as? ProjectNavigationController {
                vc.project = navController.project
            }
            _viewControllers.append(vc)
        }
        
        self.viewControllers = _viewControllers
        
        projectTabBar.mainTabBarButton_didPress(sender: projectTabBar.tabBarButtons.first!)
    }
}

//MARK: Tab Bar Delegate
extension ProjectTabBarController: ProjectTabBarDelegate {
    func mainTabBar(mainTabBar: ProjectTabBar, didSelectTabBarButton tabBarButton: ProjectTabBarButton.TabBarButtonTypes) {
        self.selectedIndex = tabBarButton.rawValue
        if let navigationController = self.navigationController as? MainNavigationController {
            navigationController.mainNavBar.titleLabel.text = tabBarButton.title
        }
    }
}
