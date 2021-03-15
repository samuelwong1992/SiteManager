//
//  Date + Utilities.swift
//  ChildcareApp
//
//  Created by Samuel Wong on 10/8/19.
//  Copyright © 2019 Samuel Wong. All rights reserved.
//

import UIKit

extension Date {
    enum DayOfWeek: Int {
        case Sunday = 1
        case Monday
        case Tuesday
        case Wednesday
        case Thursday
        case Friday
        case Saturday
        
        var title: String {
            switch self {
            case .Sunday : return "Sunday"
            case .Monday : return "Monday"
            case .Tuesday : return "Tuesday"
            case .Wednesday : return "Wednesday"
            case .Thursday : return "Thursday"
            case .Friday : return "Friday"
            case .Saturday : return "Saturday"
            }
        }
    }
    
    func dayOfWeek() -> Int? {
        let cal: Calendar = Calendar.current
        let comp: DateComponents = (cal as NSCalendar).components(.weekday, from: self)
        return comp.weekday
    }
    
    var nameOfDayOfWeek: String {
        let cal: Calendar = Calendar.current
        let comp: DateComponents = (cal as NSCalendar).components(.weekday, from: self)
        if let weekday = comp.weekday {
            if let day = DayOfWeek(rawValue: weekday) {
                return day.title
            }
        }
        
        return ""
    }
    
    var day:Int {
        get {
            return (Calendar.current as NSCalendar).component(.day, from: self)
        }
    }
    
    var month:Int {
        get {
            return (Calendar.current as NSCalendar).component(.month, from: self)
        }
    }
    
    var nameOfMonth: String {
        get {
            let dateFormat:DateFormatter = DateFormatter()
            dateFormat.dateFormat = "MMM"
            return dateFormat.string(from: self)
        }
    }
    
    var year:Int {
        get {
            return (Calendar.current as NSCalendar).component(.year, from: self)
        }
    }
    
    var timeReadableString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: self)
    }
    
    var dayMonthReadableString: String {
        let dateFormat:DateFormatter = DateFormatter()
        let timeZone = TimeZone.current
        dateFormat.dateFormat = "dd MMM"
        dateFormat.timeZone = timeZone
        
        return dateFormat.string(from: self)
    }
    
    var dayMonthYearReadableString: String {
        let dateFormat:DateFormatter = DateFormatter()
        let timeZone = TimeZone.current
        dateFormat.dateFormat = "dd MMM, yy"
        dateFormat.timeZone = timeZone
        
        return dateFormat.string(from: self)
    }
    
    var monthYearReadableString: String {
        let dateFormat:DateFormatter = DateFormatter()
        let timeZone = TimeZone.current
        dateFormat.dateFormat = "MMM, yyyy"
        dateFormat.timeZone = timeZone
        
        return dateFormat.string(from: self)
    }
    
    var timeDayMonthYearReadableString: String {
        let dateFormat:DateFormatter = DateFormatter()
        let timeZone = TimeZone.current
        dateFormat.dateFormat = "h:mm a - dd MMM, yyyy"
        dateFormat.timeZone = timeZone
        
        return dateFormat.string(from: self)
    }
    
    func dateInDaysFromNow(numberOfDays: Int) -> Date {
        return self.addingTimeInterval(Double(numberOfDays)*24*60*60)
    }
    
    func standardizedDate() -> Date {
        let calendar = Calendar.current
        let date = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: self)
        return date!
    }
    
    static var currentDay:Int {
        return (Calendar.current as NSCalendar).component(.day, from: Date())
    }
    
    static var currentMonth:Int {
        return (Calendar.current as NSCalendar).component(.month, from: Date())
    }
    
    static var currentYear:Int {
        return (Calendar.current as NSCalendar).component(.year, from: Date())
    }
    
    func isEqualToDate(date: Date) -> Bool {
        return self.compare(date) == .orderedSame
    }
    
    func asTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ssZ"
        return dateFormatter.string(from: self)
    }
    
    func asDateTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        return dateFormatter.string(from: self)
    }
    
    func asDatestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    static func asDateStampOrNA(date: Date?) -> String {
        if date == nil { return "N/A" }
        return date!.dayMonthYearReadableString
    }
    
    static func asDateStampNoDayOrNA(date: Date?) -> String {
        if date == nil { return "N/A" }
        return date!.monthYearReadableString
    }
    
    func isGreaterThanDate(_ dateToCompare : Date) -> Bool
    {
        return self.compare(dateToCompare) == ComparisonResult.orderedDescending
    }
    
    
    func isLessThanDate(_ dateToCompare : Date) -> Bool
    {
        return self.compare(dateToCompare) == ComparisonResult.orderedAscending
    }
    
    func isGreaterThanOrEqualToDate(_ dateToCompare : Date) -> Bool {
        return self.isGreaterThanDate(dateToCompare) || self.compare(dateToCompare) == ComparisonResult.orderedSame
    }
    
    func isLessThanOrEqualToDate(_ dateToCompare : Date) -> Bool {
        return self.isLessThanDate(dateToCompare) || self.compare(dateToCompare) == ComparisonResult.orderedSame
    }
    
    static func createDay(withYear year: Int, month: Int, day: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(year: year, month: month, day: day)
        return calendar.date(from: components)!
    }
}

extension TimeInterval {
    func intervalSinceReadableString() -> String {
        let hours = Int(floor((self/(60.0*60.0))))
        var minutes = Int(floor((self/(60.0))))
        
        var toReturn: String = ""
        
        if abs(hours) > 0 {
            toReturn += "\(abs(hours)) hour\(abs(hours) > 1 ? "s" : ""), "
            minutes -= hours * 60
        }
        toReturn += "\(abs(minutes)) minutes \(self < 0 ? "until" : "since")"
        
        
        return toReturn
    }
}
