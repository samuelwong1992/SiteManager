//
//  MainTabBar.swift
//  Site Manager
//
//  Created by Samuel Wong on 18/5/20.
//  Copyright © 2020 xPhase. All rights reserved.
//

import UIKit

protocol MainTabBarDelegate {
    func mainTabBar(mainTabBar: MainTabBar, didSelectTabBarButton tabBarButton: TabBarButton.TabBarButtonTypes)
}

class MainTabBar: UIView {
    
    @IBOutlet weak var calendarButton: TabBarButton!
    @IBOutlet weak var projectsButton: TabBarButton!
    @IBOutlet weak var settingsButton: TabBarButton!
    
    var tabBarButtons: [TabBarButton] {
        return [
            calendarButton,
            projectsButton,
            settingsButton
        ]
    }
    
    var _delegate: MainTabBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        super.loadViewFromNib(StoryboardConstants.Nib.MainTabBar.identifier, forClass: MainTabBar.self)
        
        initialize()
    }
}

//MARK: Initialization
extension MainTabBar {
    func initialize() {
//        self.backgroundColor = Theme.Colors.White.uiColor
        self.backgroundColor = UIColor.white
        for i in 0 ..< tabBarButtons.count {
            if let tabBarButton = TabBarButton.TabBarButtonTypes(rawValue: i) {
                tabBarButtons[i].tabBarButtonType = tabBarButton
                tabBarButtons[i].addTarget(self, action: #selector(mainTabBarButton_didPress(sender:)), for: .touchUpInside)
            }
        }
        
        setSelectButtonUI(selectedTabBarButton: tabBarButtons[0].tabBarButtonType)
    }
}

//MARK: Button Handlers
@objc extension MainTabBar {
    func mainTabBarButton_didPress(sender: TabBarButton) {
        setSelectButtonUI(selectedTabBarButton: sender.tabBarButtonType)
        _delegate?.mainTabBar(mainTabBar: self, didSelectTabBarButton: sender.tabBarButtonType)
    }
}

//MARK: Helpers
extension MainTabBar {
    func setSelectButtonUI(selectedTabBarButton: TabBarButton.TabBarButtonTypes) {
        for i in 0 ..< tabBarButtons.count {
            if let tabBarButton = TabBarButton.TabBarButtonTypes(rawValue: i) {
                let button = tabBarButtons[i]
                button.setSelected(selectedTabBarButton == tabBarButton)
            }
        }
    }
}

//MARK: Tab Bar Button Utility
class TabBarButton: UIButton {
    enum TabBarButtonTypes: Int, CaseIterable {
        case Projects = 0
        case Calendar
        case Settings
        
        var title: String {
            switch self {
            case .Calendar : return "Calendar"
            case .Projects : return "Projects"
            case .Settings : return "Settings"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .Calendar : return nil
            case .Projects : return nil
            case .Settings : return nil
            }
        }
        
        var selectedImage: UIImage? {
            switch self {
            case .Calendar : return nil
            case .Projects : return nil
            case .Settings : return nil
            }
        }
        
        var storyboard: UIStoryboard {
            switch self {
            case .Calendar : return StoryboardConstants.Storyboard.Calendar.storyboard
            case .Projects : return StoryboardConstants.Storyboard.Projects.storyboard
            case .Settings : return StoryboardConstants.Storyboard.Settings.storyboard
            }
        }
    }
    
    var tabBarButtonType: TabBarButton.TabBarButtonTypes! {
        didSet {
            self.setTitle(tabBarButtonType.title, for: .normal)
//            self.setTitle(nil, for: .normal)
//            self.setImage(tabBarButtonType.image, for: .normal)
        }
    }
    
    func setSelected(_ selected: Bool) {
        if tabBarButtonType != nil {
//            self.setImage(selected ? tabBarButtonType.selectedImage : tabBarButtonType.image, for: .normal)
        }
    }
}
