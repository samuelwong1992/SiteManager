//
//  NewProjectViewController.swift
//  Site Manager
//
//  Created by Samuel Wong on 3/12/21.
//

import UIKit

protocol NewProjectViewControllerDelegate {
    func newProjectViewController(newProjectViewController: NewProjectViewController, didCreateProject project: Project)
}

class NewProjectViewController: UIViewController {
    
    static var viewController: NewProjectViewController? {
        return StoryboardConstants.Storyboard.Projects.storyboard.instantiateViewController(withIdentifier: StoryboardConstants.ViewController.NewProjectViewController.identifier) as? NewProjectViewController
    }

    @IBOutlet weak var nameInputField: StandardInputField!
    @IBOutlet weak var locationInputField: StandardInputField!
    
    @IBOutlet weak var colorPickerIndicator: UIView!
    @IBOutlet weak var colourButton: UIButton!
    
    @IBOutlet weak var addButton: PrimaryButton!
    
    var _delegate: NewProjectViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
}

//MARK: Initialization
extension NewProjectViewController {
    func initialize() {
        self.addBackgroundViewDismissKeyboardRecognizer()
        
        colorPickerIndicator.addBorder(colour: .blue)
        colorPickerIndicator.setRoundedCorners()
        colourButton.addTarget(self, action: #selector(colourButton_didPress), for: .touchUpInside)
        
        addButton.addTarget(self, action: #selector(addButton_didPress), for: .touchUpInside)
    }
}

//MARK: Button Handlers
@objc extension NewProjectViewController {
    func colourButton_didPress() {
        let colourPicker = UIColorPickerViewController()
        colourPicker.delegate = self
        self.present(colourPicker, animated: true, completion: nil)
    }
    
    func addButton_didPress() {
        guard nameInputField.hasText else { UIAlertController.showAlertWithError(viewController: self, errorString: "Name Input Field is required"); return }
        guard locationInputField.hasText else { UIAlertController.showAlertWithError(viewController: self, errorString: "Location Input Field is required"); return }
        guard colorPickerIndicator.backgroundColor != nil else { UIAlertController.showAlertWithError(viewController: self, errorString: "A Project Colour is required"); return }
        
        let projectContainer = ProjectHelpers.createProject(withName: nameInputField.text!, location: locationInputField.text!, color: colorPickerIndicator.backgroundColor!.hexCode)
        if let error = projectContainer.error {
            UIAlertController.showAlertWithError(viewController: self, error: error)
        } else if let project = projectContainer.project {
            self.dismiss(animated: true) {
                self._delegate?.newProjectViewController(newProjectViewController: self, didCreateProject: project)
            }
        }
    }
}

//MARK: Colour Picker Delegate
extension NewProjectViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        colorPickerIndicator.backgroundColor = color
    }
}
