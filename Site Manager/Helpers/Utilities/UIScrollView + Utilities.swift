//
//  UIScrollView + Utilities.swift
//  DriveIt
//
//  Created by Samuel Wong on 20/5/20.
//  Copyright © 2020 xPhase. All rights reserved.
//

import UIKit

extension UIScrollView {
    func addFadeInAndOutVertically() {
        let identifier = "kVMaskLayer"
        if self.superview != nil {
            if superview!.layer.sublayers != nil {
                for svLayer in superview!.layer.sublayers! {
                    if svLayer.name == identifier {
                        svLayer.removeFromSuperlayer()
                    }
                }
            }
            
            let innerColor = UIColor(white: 1.0, alpha: 0.0).cgColor
            let outerColor = UIColor(white: 1.0, alpha: 1.0).cgColor;

            // define a vertical gradient (up/bottom edges)
            let colors = [outerColor, innerColor,innerColor,outerColor]

            let vMaskLayer : CAGradientLayer = CAGradientLayer()// layer];
            // without specifying startPoint and endPoint, we get a vertical gradient
            vMaskLayer.opacity = 0.7
            vMaskLayer.colors = colors;
            vMaskLayer.locations = [0.0, 0.05,0.95,1.0];
            vMaskLayer.frame = self.frame;
            vMaskLayer.name = identifier

            // you must add the mask to the root view, not the scrollView, otherwise
            //  the masks will move as the user scrolls!
            self.superview!.layer.addSublayer(vMaskLayer)
        }
    }
}
