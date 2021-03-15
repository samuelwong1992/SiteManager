//
//  UIDevice + Utilities.swift
//  DriveIt
//
//  Created by Samuel Wong on 15/6/20.
//  Copyright © 2020 xPhase. All rights reserved.
//

import UIKit

extension UIDevice {
    static func isBigScreen() -> Bool {
        return UIScreen.main.bounds.width >= 640
    }
}
