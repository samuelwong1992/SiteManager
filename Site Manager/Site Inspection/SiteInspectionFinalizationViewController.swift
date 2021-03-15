//
//  SiteInspectionFinalizationViewController.swift
//  Site Manager
//
//  Created by Samuel Wong on 5/3/21.
//

import UIKit

class SiteInspectionFinalizationViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var whsTextField: UITextField!
    
    @IBOutlet weak var finishButton: UIButton!
    
    var siteInspection: SiteInspection!
    
    static var viewController: SiteInspectionFinalizationViewController? {
        return StoryboardConstants.Storyboard.SiteInspection.storyboard.instantiateViewController(identifier: StoryboardConstants.ViewController.SiteInspectionFinalizationViewController.identifier) as? SiteInspectionFinalizationViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
}

//MARK: Initialization
extension SiteInspectionFinalizationViewController {
    func initialize() {
        whsTextField.isEnabled = false
        
        segmentedControl.addTarget(self, action: #selector(segmentedControl_didChange), for: .valueChanged)
        finishButton.addTarget(self, action: #selector(finishButton_didPress), for: .touchUpInside)
    }
}

//MARK: Button Handlers
@objc extension SiteInspectionFinalizationViewController {
    func finishButton_didPress() {
        let alert = UIAlertController(title: "Finish", message: "Are you ready to complete this Site Inspection? Do you want to generate a report now?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Generate Later", style: .default, handler: { (action) in
            if let siteInspection = self.siteInspection {
                siteInspection.completed = true
            }
            
            if let navigationController = self.presentingViewController as? SiteInspectionNavigationController {
                navigationController.presentingViewController?.dismiss(animated: true, completion: {
                    navigationController._delegate?.didClose(forMainNavigationController: navigationController)
                })
            }
        }))
        alert.addAction(UIAlertAction(title: "Generate Now", style: .default, handler: { (action) in
            if let siteInspection = self.siteInspection {
                siteInspection.completed = true
            }
            
            if let navigationController = self.presentingViewController as? SiteInspectionNavigationController {
                navigationController.presentingViewController?.dismiss(animated: true, completion: {
                    navigationController._delegate?.didClose(forMainNavigationController: navigationController)
                })
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func segmentedControl_didChange() {
        whsTextField.isEnabled = segmentedControl.selectedSegmentIndex != 0
    }
}
