//
//  SiteInspectionInitializationViewController.swift
//  Site Manager
//
//  Created by Samuel Wong on 3/3/21.
//

import UIKit

class SiteInspectionInitializationViewController: UIViewController {

    static var viewController: SiteInspectionInitializationViewController? {
        return StoryboardConstants.Storyboard.SiteInspectionStoryboard.storyboard.instantiateViewController(identifier: StoryboardConstants.ViewController.SiteInspectionInitializationViewController.identifier) as? SiteInspectionInitializationViewController
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
    var project: Project!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
}

//MARK: Initialization
extension SiteInspectionInitializationViewController {
    func initialize() {
        self.addBackgroundViewDismissKeyboardRecognizer()
        
        if let siteInspection = self.siteInspection {
            reportNameTextField.text = siteInspection.name
            introductionTextField.text = siteInspection.introduction
            presentOnSiteTextField.text = siteInspection.presentOnSite
            weatherTextField.text = siteInspection.weatherConditions
            workTextField.text = siteInspection.workInProgress
            attentionTextField.text = siteInspection.attention
            subjectTextField.text = siteInspection.subject
        }
        
        
        beginButton.addTarget(self, action: #selector(beginButton_didPress), for: .touchUpInside)
    }
}

//MARK: Button Handlers
@objc extension SiteInspectionInitializationViewController {
    func beginButton_didPress() {
        
        if siteInspection != nil {
            siteInspection!.name = reportNameTextField.text ?? ""
            siteInspection!.introduction = introductionTextField.text ?? ""
            siteInspection!.presentOnSite = presentOnSiteTextField.text ?? ""
            siteInspection!.weatherConditions = weatherTextField.text ?? ""
            siteInspection!.workInProgress = workTextField.text ?? ""
            siteInspection!.attention = attentionTextField.text ?? ""
            siteInspection!.subject = subjectTextField.text ?? ""
            
            do {
                try CoreDataHelper.context.save()
            } catch {
                UIAlertController.showAlertWithError(viewController: self, error: error)
            }

        } else {
            if let vc = DrawingsViewController.viewController {
                vc.project = project
                vc._delegate = self
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}

extension SiteInspectionInitializationViewController: DrawingsViewControllerDelegate {
    func drawingsViewController(drawingsViewController: DrawingsViewController, didSelectAttachment attachment: Attachment) {}
    
    func drawingsViewController(drawingsViewController: DrawingsViewController, didSelectDrawing drawing: Drawings) {
        let siteInspectionResponse = SiteInspectionHelpers.createSiteInspection(withName: reportNameTextField.text ?? "", withDrawing: drawing, forProject: project, introduction: introductionTextField.text ?? "", presentOnSite: presentOnSiteTextField.text ?? "", weatherConditions: weatherTextField.text ?? "", workInProgress: workTextField.text ?? "", attention: attentionTextField.text ?? "", subject: subjectTextField.text ?? "")
        if let error = siteInspectionResponse.error {
            UIAlertController.showAlertWithError(viewController: self, error: error)
        } else if let siteInspection = siteInspectionResponse.siteInspection {
            drawingsViewController.dismiss(animated: true) {
                if let vc = SiteInspectionNavigationController.navigationController {
                    vc.modalPresentationStyle = .overFullScreen
                    vc.siteInspection = siteInspection
                    vc._delegate = self
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
}

extension SiteInspectionInitializationViewController: MainNavigationControllerDelegate {
    func didClose(forMainNavigationController mainNavigationController: MainNavigationController) {
        self.dismiss(animated: true, completion: nil)
    }
}
