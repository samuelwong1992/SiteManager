//
//  String + Utilities.swift
//  Dealership
//
//  Created by Samuel Wong on 18/9/19.
//  Copyright © 2019 xPhase. All rights reserved.
//
import UIKit

extension String {
    static func isNilOrEmpty(_ string: String?) -> Bool {
        if string == nil { return true }
        if string!.count <= 0 { return true }
        
        return false
    }
    
    static func selfOrNA(_ string: String?) -> String {
        return String.isNilOrEmpty(string) ? "N/A" : string!
    }
    
    func asDateFromDateTimeStamp() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            return dateFormatter.date(from: self)
        }
    }
    
    func asDateFromDateStamp() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
    
    func isValidVin() -> Bool {
        if contains("o") || contains("O") { return false }
        if contains("i") || contains("I") { return false }
        if contains(" ") { return false }
        
        let validString = CharacterSet.alphanumerics
        if rangeOfCharacter(from: validString.inverted) != nil { return false }
        
        return true
    }
    
    func isValidEmail() -> Bool {
        if !contains("@") { return false }
        let subs = split(separator: "@")
        if let last = subs.last {
            if !last.contains(".") { return false }
        } else {
            return false
        }
        
        return true
    }
}
