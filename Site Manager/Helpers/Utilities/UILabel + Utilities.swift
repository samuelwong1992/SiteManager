//
//  UILabel + Utilities.swift
//  DriveIt
//
//  Created by Samuel Wong on 25/5/20.
//  Copyright © 2020 xPhase. All rights reserved.
//

import UIKit

extension UILabel {
    func animate(font: UIFont, duration: TimeInterval) {
        let labelScale = self.font.pointSize / font.pointSize
        self.font = font
        let oldTransform = transform
        transform = transform.scaledBy(x: labelScale, y: labelScale)
         
        setNeedsUpdateConstraints()
        UIView.animate(withDuration: duration) {
            self.transform = oldTransform
            self.layoutIfNeeded()
        }
    }
}
