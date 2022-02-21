//
//  ProfileViewController.swift
//  Site Manager
//
//  Created by Samuel Wong on 11/2/2022.
//

import UIKit
import PhotosUI

class ProfileViewController: UIViewController, ScrollViewTextFieldHandler {
    
    static var viewController: ProfileViewController? {
        return StoryboardConstants.Storyboard.Profile.storyboard.instantiateInitialViewController() as? ProfileViewController
    }

    @IBOutlet weak var companyNameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var suburbField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var postcodeField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var abnField: UITextField!
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var saveButton: PrimaryButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var logo: UIImage!
    
    var scrollableView: UIScrollView {
        return scrollView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
}

extension ProfileViewController {
    func initialize() {
        if let profile = ProfileHelpers.profile {
            companyNameField.text = profile.companyName
            addressField.text = profile.address1
            suburbField.text = profile.suburb
            stateField.text = profile.state
            postcodeField.text = profile.postcode
            phoneField.text = profile.phone
            abnField.text = profile.abn
            logoImageView.image = profile.logo
        }
        
        logoImageView.setRoundedCorners()
        logoImageView.addBorder(colour: Themes.Color.Primary.uiColor)
        logoImageView.isUserInteractionEnabled = true
        logoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logoImageView_didTap)))
        
        saveButton.addTarget(self, action: #selector(saveButton_didPress), for: .touchUpInside)
        
        self.addBackgroundViewDismissKeyboardRecognizer()
        self.addSVTFKeyboardListeners()
        
    }
}

@objc extension ProfileViewController {
    func saveButton_didPress() {
        guard companyNameField.hasText else { UIAlertController.showAlertWithError(viewController: self, errorString: "Company Name is required"); return; }
        guard addressField.hasText else { UIAlertController.showAlertWithError(viewController: self, errorString: "Address is required"); return; }
        guard suburbField.hasText else { UIAlertController.showAlertWithError(viewController: self, errorString: "Suburb is required"); return; }
        guard stateField.hasText else { UIAlertController.showAlertWithError(viewController: self, errorString: "State is required"); return; }
        guard postcodeField.hasText else { UIAlertController.showAlertWithError(viewController: self, errorString: "Postcode is required"); return; }
        guard phoneField.hasText else { UIAlertController.showAlertWithError(viewController: self, errorString: "Phone is required"); return; }
        guard abnField.hasText else { UIAlertController.showAlertWithError(viewController: self, errorString: "ABN is required"); return; }
        
        if let profile = ProfileHelpers.profile {
            profile.companyName = companyNameField.text
            profile.address1 = addressField.text
            profile.suburb = suburbField.text
            profile.state = stateField.text
            profile.postcode = postcodeField.text
            profile.phone = phoneField.text
            profile.abn = abnField.text
            
            if logo != nil {
                if let path = logo.saveImageToFileManager() {
                    profile.logoPath = path
                }
            }
            
            let error = profile.update()
            if let error = error {
                UIAlertController.showAlertWithError(viewController: self, error: error)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            let profileContainer = ProfileHelpers.create(companyName: companyNameField.text ?? "", address1: addressField.text ?? "", suburb: suburbField.text ?? "", state: stateField.text ?? "", postcode: postcodeField.text ?? "", phone: phoneField.text ?? "", abn: abnField.text ?? "", logo: logo)
            if let error = profileContainer.error {
                UIAlertController.showAlertWithError(viewController: self, error: error)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func logoImageView_didTap() {
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
}

extension ProfileViewController {
    func openImagePicker() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK: Camera Picker Delegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        self.logo = image
        self.logoImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: PH Picker Delegate
extension ProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                DispatchQueue.main.async {
                    if let image = object as? UIImage {
                        self.logo = image
                        self.logoImageView.image = image
                    }
                }
            })
        }
        self.dismiss(animated: true, completion: nil)
    }
}
