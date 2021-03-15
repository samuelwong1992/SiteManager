//
//  NSLayoutConstraint + Utilities.swift
//  DriveIt
//
//  Created by Samuel Wong on 19/5/20.
//  Copyright © 2020 xPhase. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    func animateToConstant(newConstant: CGFloat, onView view: UIView, completion: ((Bool) -> Void)? = nil) {
        self.constant = newConstant
        UIView.animate(withDuration: 0.4, animations: {
            view.layoutIfNeeded()
        }, completion: { (fin) in
            if let completion = completion {
                completion(fin)
            }
        })
    }
    
    func animateToActive(newActive: Bool, onView view: UIView, completion: ((Bool) -> Void)? = nil) {
        self.isActive = newActive
        UIView.animate(withDuration: 0.4, animations: {
            view.layoutIfNeeded()
        }, completion: { (fin) in
            if let completion = completion {
                completion(fin)
            }
        })
    }
}
