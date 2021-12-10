//
//  ProjectTabBar.swift
//  Site Manager
//
//  Created by Samuel Wong on 9/2/21.
//

import UIKit

protocol ProjectTabBarDelegate {
    func mainTabBar(mainTabBar: ProjectTabBar, didSelectTabBarButton tabBarButton: ProjectTabBarButton.TabBarButtonTypes)
}

class ProjectTabBar: UIView {
    
    @IBOutlet weak var projectDrawingsButton: ProjectTabBarButton!
    @IBOutlet weak var inspectionReportsButton: ProjectTabBarButton!
    @IBOutlet weak var photosButton: ProjectTabBarButton!
    @IBOutlet weak var shopDrawingsButton: ProjectTabBarButton!
    
    var tabBarButtons: [ProjectTabBarButton] {
        return [
            projectDrawingsButton,
            inspectionReportsButton,
            photosButton,
            shopDrawingsButton
        ]
    }
    
    var _delegate: ProjectTabBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        super.loadViewFromNib(StoryboardConstants.Nib.ProjectTabBar.identifier, forClass: ProjectTabBar.self)
        
        initialize()
    }
}

//MARK: Initialization
extension ProjectTabBar {
    func initialize() {
        self.backgroundColor = .white
        for i in 0 ..< tabBarButtons.count {
            if let tabBarButton = ProjectTabBarButton.TabBarButtonTypes(rawValue: i) {
                tabBarButtons[i].tabBarButtonType = tabBarButton
                tabBarButtons[i].addTarget(self, action: #selector(mainTabBarButton_didPress(sender:)), for: .touchUpInside)
            }
        }
        
        setSelectButtonUI(selectedTabBarButton: tabBarButtons[0].tabBarButtonType)
    }
}

//MARK: Button Handlers
@objc extension ProjectTabBar {
    func mainTabBarButton_didPress(sender: ProjectTabBarButton) {
        setSelectButtonUI(selectedTabBarButton: sender.tabBarButtonType)
        _delegate?.mainTabBar(mainTabBar: self, didSelectTabBarButton: sender.tabBarButtonType)
    }
}

//MARK: Helpers
extension ProjectTabBar {
    func setSelectButtonUI(selectedTabBarButton: ProjectTabBarButton.TabBarButtonTypes) {
        for i in 0 ..< tabBarButtons.count {
            if let tabBarButton = ProjectTabBarButton.TabBarButtonTypes(rawValue: i) {
                let button = tabBarButtons[i]
                button.setSelected(selectedTabBarButton == tabBarButton)
            }
        }
    }
}

//MARK: Tab Bar Button Utility
class ProjectTabBarButton: UIButton {
    enum TabBarButtonTypes: Int, CaseIterable {
        case ProjectDrawings = 0
        case InspectionReports
        case Photos
        case ShopDrawings
        
        var title: String {
            switch self {
            case .ProjectDrawings : return "Project Drawings"
            case .InspectionReports : return "Inspection Reports"
            case .Photos : return "Photos"
            case .ShopDrawings : return "Shop Drawings"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .ProjectDrawings : return nil
            case .InspectionReports : return nil
            case .Photos : return nil
            case .ShopDrawings : return nil
            }
        }
        
        var selectedImage: UIImage? {
            switch self {
            case .ProjectDrawings : return nil
            case .InspectionReports : return nil
            case .Photos : return nil
            case .ShopDrawings : return nil
            }
        }
        
        var viewController: ProjectBaseViewController? {
            switch self {
            case .ProjectDrawings : return DrawingsViewController.viewController
            case .InspectionReports : return StoryboardConstants.Storyboard.Project.storyboard.instantiateViewController(identifier: StoryboardConstants.ViewController.InspectionReports.identifier)
            case .Photos :
                let vc = DrawingsViewController.viewController
                vc?.isForAttachment = true
                return vc
            case .ShopDrawings :
                let vc = DrawingsViewController.viewController
                vc?.isForAttachment = true
                vc?.isForShopDrawing = true
                return vc
            }
        }
    }
    
    var tabBarButtonType: ProjectTabBarButton.TabBarButtonTypes! {
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
