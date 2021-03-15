//
//  UIAlert + Utilities.swift
//  BMW
//
//  Created by Samuel Wong on 2/10/2016.
//  Copyright © 2016 Samuel Wong. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func showAlertWithError(viewController:UIViewController, error: Error?) {
        guard let error = error else { return }
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showAlertWithError(viewController:UIViewController, errorString: String) {
        let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showAlertWithErrorNoDismiss(viewController:UIViewController, errorString: String) {
        let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showAlertWithWarning(viewController:UIViewController, warningString: String, customCompletion: ((UIAlertAction) -> Void)? = nil) {
        let string = NSAttributedString(string: "WARNING", attributes:([NSAttributedString.Key.foregroundColor : UIColor.red]))
        let alert = UIAlertController(title: "", message: warningString, preferredStyle: .alert)
        alert.setValue(string, forKey: "attributedTitle")
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: customCompletion))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showAlertWithOk(viewController:UIViewController, titleString: String, messageString: String, customCompletion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: customCompletion))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showAlertWithTextField(viewController:UIViewController, title:String, message:String, defaultText:String?, placeholder:String, keyboardType:UIKeyboardType = UIKeyboardType.alphabet, textFieldHandler:@escaping (UITextField)->Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Send", style: .default, handler: {
            alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            textFieldHandler(textField)
            // do something with textField
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            textField.placeholder = placeholder
            textField.keyboardType = keyboardType
            textField.text = defaultText
        })
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func createAlertWithError(error: Error) -> UIAlertController {
           let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
           return alert
    }
    
    static func createAlertWithError(errorString: String) -> UIAlertController {
           let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
           return alert
    }
    
    static func createAlertWithNoAction(titleString: String, messageString: String) -> UIAlertController {
        let alert = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        return alert
    }
    
    static func createAlertWithCancelAction(titleString: String, messageString: String) -> UIAlertController {
        let alert = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return alert
    }
}
