//
//  Int + Utilities.swift
//  iAppraise
//
//  Created by Samuel Wong on 19/9/19.
//  Copyright © 2019 xPhase. All rights reserved.
//

extension Int {
    var toString: String {
        return "\(self)"
    }
    
    static func asQualityOrNA(int: Int?) -> String {
        if int == nil { return "N/A" }
        
        if int == 0 { return "Bad" }
        if int == 1 { return "Average" }
        if int == 2 { return "Good" }
        
        return "N/A"
    }
    
    static func selfOrNA(int: Int?) -> String {
        if int == nil { return "N/A" }
        if int == 0 { return "N/A" }
        return "\(int!)"
    }
    
    static func selfAsPriceOrNA(int: Int?) -> String {
        if int == nil { return "N/A" }
        if int == 0 { return "N/A" }
        return "$\(int!)"
    }
    
    static func selfOrBlank(int: Int?) -> String {
        if int == nil { return "" }
        return "\(int!)"
    }
    
    static func intOrNil(int: Int?) -> Int? {
        if int == nil { return nil }
        if int == 0 { return nil }
        return int
    }
}
