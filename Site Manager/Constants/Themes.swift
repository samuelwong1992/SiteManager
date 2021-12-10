//
//  Themes.swift
//  Site Manager
//
//  Created by Samuel Wong on 3/12/21.
//

import UIKit

struct Themes {
    enum Color: String {
        case Primary = "#0000FF"
        
        var uiColor: UIColor {
            return UIColor.colourWithHexString(self.rawValue)
        }
    }
}
