//
//  SecondaryButton.swift
//  Site Manager
//
//  Created by Samuel Wong on 3/12/21.
//

import UIKit

class SecondaryButton: StandardButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderColor = Themes.Color.Primary.uiColor.cgColor
        self.setTitleColor(Themes.Color.Primary.uiColor, for: .normal)
    }
}
