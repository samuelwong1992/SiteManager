//
//  StandardInputField.swift
//  Site Manager
//
//  Created by Samuel Wong on 3/12/21.
//

import UIKit

class StandardInputField: UITextField {

    private var separator: UIView?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if(separator == nil) {
            self.borderStyle = .none
            
            separator = UIView()
            separator!.backgroundColor = .gray
            
            self.addSubViewToBottom(subview: separator!, withHeight: 1)
        }
    }

}
