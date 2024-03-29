//
//  SiteInspectionNavigationController.swift
//  Site Manager
//
//  Created by Samuel Wong on 10/2/21.
//

import UIKit

class SiteInspectionNavigationController: MainNavigationController {
    static var navigationController: SiteInspectionNavigationController? {
        return StoryboardConstants.Storyboard.SiteInspectionStoryboard.storyboard.instantiateInitialViewController() as? SiteInspectionNavigationController
    }
    
    var siteInspection: SiteInspection!
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainNavBar.titleLabel.text = siteInspection.name
        
        self.mainNavBar.secondaryButton.isHidden = false
        self.mainNavBar.secondaryButton.setTitle("Finish", for: .normal)
        self.mainNavBar.secondaryButton.addTarget(self, action: #selector(secondaryButton_didPress), for: .touchUpInside)
    }
}

//MARK: Button Handlers
@objc extension SiteInspectionNavigationController {
    func secondaryButton_didPress() {
        if let pvc = self.visibleViewController as? SiteInspectionViewController {
            if let vc = SiteInspectionFinalizationViewController.viewController {
                vc.siteInspection = siteInspection
                let renderer = UIGraphicsImageRenderer(bounds: pvc.imageView.bounds)
                let image = renderer.image { rendererContext in
                    pvc.imageView.layer.render(in: rendererContext.cgContext)
                }
                vc.siteInspectionImages = [image]
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}
