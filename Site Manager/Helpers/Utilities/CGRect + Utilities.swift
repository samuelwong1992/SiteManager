//
//  CGRect.swift
//  Site Manager
//
//  Created by Samuel Wong on 5/2/21.
//

import UIKit

extension CGRect {
    func addingSize(width: CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: self.origin.x, y: self.origin.y, width: self.width + width, height: self.height + height)
    }
    
    var withZeroOrigin: CGRect {
        return CGRect(origin: CGPoint.zero, size: self.size)
    }
    
    var withZeroX: CGRect {
        return CGRect(origin: CGPoint(x: 0, y: self.origin.y), size: self.size)
    }
    
    var with1Heigh: CGRect {
        return CGRect(origin: self.origin, size: CGSize(width: self.size.width, height: 1))
    }
    
    var bottomLeftPoint: CGPoint {
        return CGPoint(x: self.origin.x, y: self.origin.y + self.size.height)
    }
    
    func withHeight(height: CGFloat) -> CGRect {
        return CGRect(origin: self.origin, size: CGSize(width: self.size.width, height: height))
    }
    
    var midpoint: CGPoint {
        return CGPoint(x: self.origin.x + self.size.width/2, y: self.origin.y + self.size.height/2)
    }
}
