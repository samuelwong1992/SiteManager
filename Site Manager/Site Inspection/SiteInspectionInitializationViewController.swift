//
//  SiteInspectionInitializationViewController.swift
//  Site Manager
//
//  Created by Samuel Wong on 3/3/21.
//

import UIKit
import PhotosUI

class SiteInspectionInitializationViewController: UIViewController {

    static var viewController: SiteInspectionInitializationViewController? {
        return StoryboardConstants.Storyboard.SiteInspectionStoryboard.storyboard.instantiateViewController(identifier: StoryboardConstants.ViewController.SiteInspectionInitializationViewController.identifier) as? SiteInspectionInitializationViewController
    }
    
    @IBOutlet weak var reportNameTextField: UITextField!
    @IBOutlet weak var introductionTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var workTextField: UITextField!
    @IBOutlet weak var attentionTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    
    @IBOutlet weak var addIntroPhotoButton: UIButton!
    
    @IBOutlet weak var beginButton: UIButton!
    
    var siteInspection: SiteInspection!
    var project: Project!
    
    var introPhoto: UIImage? {
        didSet {
            addIntroPhotoButton.setTitle(introPhoto == nil ? "Add" : "Change", for: .normal)
        }
    }
    
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
            workTextField.text = siteInspection.workInProgress
            attentionTextField.text = siteInspection.attention
            subjectTextField.text = siteInspection.subject
            
            introPhoto = siteInspection.introductionPhoto
        }
        
        addIntroPhotoButton.addTarget(self, action: #selector(addIntroPhotoButton_didPress), for: .touchUpInside)
        beginButton.addTarget(self, action: #selector(beginButton_didPress), for: .touchUpInside)
    }
}

//MARK: Button Handlers
@objc extension SiteInspectionInitializationViewController {
    func beginButton_didPress() {
        
        if siteInspection != nil {
            siteInspection!.name = reportNameTextField.text ?? ""
            siteInspection!.introduction = introductionTextField.text ?? ""
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
    
    func addIntroPhotoButton_didPress() {
        let alert = UIAlertController(title: "Add Photo", message: "Add from albumn or take photo now?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Albumn", style: .default, handler: { _ in
            self.openImagePicker()
        }))
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openImagePicker() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
}

extension SiteInspectionInitializationViewController: DrawingsViewControllerDelegate {
    func drawingsViewController(drawingsViewController: DrawingsViewController, didSelectAttachment attachment: Attachment) {}
    
    func drawingsViewController(drawingsViewController: DrawingsViewController, didSelectDrawing drawing: Drawings) {
        let siteInspectionResponse = SiteInspectionHelpers.createSiteInspection(withName: reportNameTextField.text ?? "", withDrawing: drawing, forProject: project, company: companyTextField.text ?? "", introduction: introductionTextField.text ?? "", introductionPhoto: introPhoto, workInProgress: workTextField.text ?? "", attention: attentionTextField.text ?? "", subject: subjectTextField.text ?? "")
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

//MARK: Camera Picker Delegate
extension SiteInspectionInitializationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        self.introPhoto = image
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: PH Picker Delegate
extension SiteInspectionInitializationViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                DispatchQueue.main.async {
                    if let image = object as? UIImage {
                        self.introPhoto = image
                    }
                }
            })
        }
        self.dismiss(animated: true, completion: nil)
    }
}
