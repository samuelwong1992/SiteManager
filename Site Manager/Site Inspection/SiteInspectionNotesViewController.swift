//
//  SiteInspectionNotesViewController.swift
//  Site Manager
//
//  Created by Samuel Wong on 15/2/21.
//

import UIKit

class SiteInspectionNotesViewController: UIViewController {
    
    static var viewController: SiteInspectionNotesViewController? {
        return StoryboardConstants.Storyboard.SiteInspection.storyboard.instantiateViewController(identifier: StoryboardConstants.ViewController.SiteInspectionNotesViewController.identifier) as? SiteInspectionNotesViewController
    }
    
    var inspectionTitle: String?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var actionByTextField: UITextField!
    
    @IBOutlet weak var doneButton: UIButton!
    
    var returnBlock: ((_ title: String, _ description: String, _ note: String, _ actionBy: String) -> Void)?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
    }
}

//MARK: Initialization
extension SiteInspectionNotesViewController {
    func initialize() {
        self.addBackgroundViewDismissKeyboardRecognizer()
        
        if let inspectionTitle = inspectionTitle {
            titleTextField.text = inspectionTitle
        }
        
        doneButton.addTarget(self, action: #selector(doneButton_didPress), for: .touchUpInside)
    }
}

//MARK: Button Handlers
@objc extension SiteInspectionNotesViewController {
    func doneButton_didPress() {
        if let returnBlock = returnBlock {
            returnBlock(titleTextField.text ?? "", descriptionTextField.text ?? "", noteTextField.text ?? "", actionByTextField.text ?? "")
        }
        self.dismiss(animated: true, completion: nil)
    }
}
