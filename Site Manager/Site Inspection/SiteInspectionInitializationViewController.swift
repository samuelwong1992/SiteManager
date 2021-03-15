//
//  SiteInspectionInitializationViewController.swift
//  Site Manager
//
//  Created by Samuel Wong on 3/3/21.
//

import UIKit

class SiteInspectionInitializationViewController: UIViewController {

    static var viewController: SiteInspectionInitializationViewController? {
        return StoryboardConstants.Storyboard.SiteInspection.storyboard.instantiateViewController(identifier: StoryboardConstants.ViewController.SiteInspectionInitializationViewController.identifier) as? SiteInspectionInitializationViewController
    }
    
    @IBOutlet weak var reportNameTextField: UITextField!
    @IBOutlet weak var introductionTextField: UITextField!
    @IBOutlet weak var presentOnSiteTextField: UITextField!
    @IBOutlet weak var weatherTextField: UITextField!
    @IBOutlet weak var workTextField: UITextField!
    @IBOutlet weak var attentionTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    
    @IBOutlet weak var beginButton: UIButton!
    
    var siteInspection: SiteInspection!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
}

//MARK: Initialization
extension SiteInspectionInitializationViewController {
    func initialize() {
        self.addBackgroundViewDismissKeyboardRecognizer()
        
        beginButton.addTarget(self, action: #selector(beginButton_didPress), for: .touchUpInside)
    }
}

//MARK: Button Handlers
@objc extension SiteInspectionInitializationViewController {
    func beginButton_didPress() {
        siteInspection!.name = reportNameTextField.text ?? ""
        siteInspection!.introduction = introductionTextField.text ?? ""
        siteInspection!.presentOnSite = presentOnSiteTextField.text ?? ""
        siteInspection!.weatherConditions = weatherTextField.text ?? ""
        siteInspection!.workInProgress = workTextField.text ?? ""
        siteInspection!.attention = attentionTextField.text ?? ""
        siteInspection!.subject = subjectTextField.text ?? ""
        
        if let vc = SiteInspectionNavigationController.navigationController {
            vc.modalPresentationStyle = .overFullScreen
            vc.siteInspection = siteInspection
            vc._delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension SiteInspectionInitializationViewController: MainNavigationControllerDelegate {
    func didClose(forMainNavigationController mainNavigationController: MainNavigationController) {
        self.dismiss(animated: true, completion: nil)
    }
}
