//
//  NSDateExtension.swift
//  Carfix
//
//  Created by Re Foong Lim on 26/02/2016.
//  Copyright © 2016 Re Foong Lim. All rights reserved.
//

import Foundation

extension Date
{
    static func getDate(format: String) -> Date?
    {
        if format.isEmpty == false
        {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "d MMM yyyy"
            return dateFormatter.date(from: format)
        }
        else
        {
            return nil
        }
    }
    
    func smallerThan(date: Date?) -> Bool {
        if date.isEmpty {
            return false
        }
        switch Calendar.current.compare(self, to: date!, toGranularity: .second) {
        case .orderedAscending:
            return true
        default:
            return false
        }
    }
    func biggerThan(date: Date?) -> Bool {
        if date.isEmpty {
            return false
        }
        switch Calendar.current.compare(self, to: date!, toGranularity: .second) {
        case .orderedAscending:
            return false
        default:
            return true
        }
    }
    
    func forDisplay() -> String? {
        let now = Date()
        
        if  self.biggerThan(date: Date(timeIntervalSinceNow: -60)) {
            return "Few seconds ago"
        }
        else if self.biggerThan(date: Date(timeIntervalSinceNow: -60 * 2)) {
            return "1 minute ago"
        }
        else if self.biggerThan(date: Date(timeIntervalSinceNow: -60 * 60)) {
            return "\(Date.toMinutes(from: now.timeIntervalSince(self))) minutes ago"
        }
        else if self.biggerThan(date: Date(timeIntervalSinceNow: -60 * 60 * 2)) {
            return "An hours ago"
        }
        else if self.biggerThan(date: Date(timeIntervalSinceNow: -60 * 60 * 24)) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            dateFormatter.locale = Locale.current
            return dateFormatter.string(from: self)
        }
        else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM yyyy"
            dateFormatter.locale = Locale.current
            return dateFormatter.string(from: self)
        }
    }
    
    func toDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    func toTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
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
    
    init?(string: String) {
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
                var dateString: String? = string
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale.current
                if string.contains("T") && string.contains("-") {
                    if string.contains(".") {
                        dateString = dateString?.components(separatedBy: ".").first
                    }
                    dateFormatter.dateFormat = "y-MM-dd'T'H:mm:ss"
                } else {
                    dateFormatter.dateFormat = "d MMM yyyy, h:mm a"
                }
                self.init(timeIntervalSince1970: dateFormatter.date(from: dateString!)!.timeIntervalSince1970)
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale.current
                dateFormatter.dateFormat = "d MMM yyyy"
                self.init(timeIntervalSince1970: dateFormatter.date(from: string)!.timeIntervalSince1970)
            }
        }
    }
    
    init?(year: Int, month: Int, day: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "d M y"
        self.init(timeIntervalSince1970: dateFormatter.date(from: "\(day) \(month) \(year)")!.timeIntervalSince1970)
    }
}

