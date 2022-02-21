//
//  NSMutableAttributedString + Utilities.swift
//  Site Manager
//
//  Created by Samuel Wong on 10/2/2022.
//

import Foundation

extension NSMutableAttributedString {
    func addNewLine() {
        self.append(NSAttributedString(string: "\n"))
    }
}
