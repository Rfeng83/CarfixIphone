//
//  NSDateExtension.swift
//  Carfix
//
//  Created by Re Foong Lim on 26/02/2016.
//  Copyright © 2016 Re Foong Lim. All rights reserved.
//

import Foundation

extension NSDate
{
    func smallerThan(date: NSDate?) -> Bool {
        if date.isEmpty {
            return false
        }
        switch NSCalendar.current.compare(self as Date, to: date! as Date, toGranularity: .second) {
        case .orderedAscending:
            return true
        default:
            return false
        }
    }
    func biggerThan(date: NSDate?) -> Bool {
        if date.isEmpty {
            return false
        }
        switch NSCalendar.current.compare(self as Date, to: date! as Date, toGranularity: .second) {
        case .orderedAscending:
            return false
        default:
            return true
        }
    }
    
    func forDisplay() -> String? {
        let now = NSDate()
        
        if  self.biggerThan(date: NSDate(timeIntervalSinceNow: -60)) {
            return "Few seconds ago"
        }
        else if self.biggerThan(date: NSDate(timeIntervalSinceNow: -60 * 2)) {
            return "1 minute ago"
        }
        else if self.biggerThan(date: NSDate(timeIntervalSinceNow: -60 * 60)) {
            return "\(NSDate.toMinutes(from: now.timeIntervalSince(self as Date))) minutes ago"
        }
        else if self.biggerThan(date: NSDate(timeIntervalSinceNow: -60 * 60 * 2)) {
            return "An hours ago"
        }
        else if self.biggerThan(date: NSDate(timeIntervalSinceNow: -60 * 60 * 24)) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            dateFormatter.locale = NSLocale.current
            return dateFormatter.string(from: self as Date)
        }
        else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM yyyy"
            dateFormatter.locale = NSLocale.current
            return dateFormatter.string(from: self as Date)
        }
    }
    
    func toDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        dateFormatter.locale = NSLocale.current
        return dateFormatter.string(from: self as Date)
    }
    
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = NSLocale.current
        return dateFormatter.string(from: self as Date)
    }
    
    static func toSeconds(from: TimeInterval) -> Int32 {
        return Convert(from).to()!
    }
    static func toMinutes(from: TimeInterval) -> Int32 {
        return Convert(from / 60).to()!
    }
    static func toHours(from: TimeInterval) -> Int32 {
        return Convert(from / 60 / 60).to()!
    }
    static func toDays(from: TimeInterval) -> Int32 {
        return Convert(from / 60 / 60 / 24).to()!
    }
    
    convenience init?(string: String) {
        if string.isEmpty {
            return nil
        } else {
            let prefix = "/Date("
            let suffix = ")/"
            if string.hasPrefix(prefix) && string.hasSuffix(suffix) {
                let from = string.index(after: prefix.endIndex)
                let to = string.index(string.endIndex, offsetBy: -suffix.characters.count)
                guard let milliSeconds = Double(string[from ..< to]) else {
                    return nil
                }
                self.init(timeIntervalSince1970: milliSeconds/1000.0)
            } else if (string.contains(":")) {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = "d MMM yyyy, h:mm a"
                self.init(timeIntervalSince1970: dateFormatter.date(from: string)!.timeIntervalSince1970)
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = "d MMM yyyy"
                self.init(timeIntervalSince1970: dateFormatter.date(from: string)!.timeIntervalSince1970)
            }
        }
    }
}
