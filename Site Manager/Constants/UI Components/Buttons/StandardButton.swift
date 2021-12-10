//
//  StandardButton.swift
//  Site Manager
//
//  Created by Samuel Wong on 3/12/21.
//

import UIKit

class StandardButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.height/2
    }
}
