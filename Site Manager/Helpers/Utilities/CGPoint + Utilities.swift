//
//  CGPoint + Utilities.swift
//  Site Manager
//
//  Created by Samuel Wong on 12/2/21.
//

import UIKit

extension CGPoint {
    func midPointTo(point: CGPoint) -> CGPoint {
        return CGPoint(x: (self.x + point.x)/2, y: (self.y + point.y)/2)
    }
    
    func translatedToProportionalArea(size1: CGSize, size2: CGSize, zoomScale: CGFloat) -> CGPoint {
        return CGPoint(x: ((self.x*size1.width)/size2.width)*zoomScale, y: ((self.y*size1.height)/size2.height)*zoomScale)
    }
}
