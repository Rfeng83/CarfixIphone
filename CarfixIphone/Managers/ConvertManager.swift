//
//  ConvertManager.swift
//  Carfix
//
//  Created by Re Foong Lim on 26/02/2016.
//  Copyright © 2016 Re Foong Lim. All rights reserved.
//

import Foundation
class Convert
{
    var mValue: Any?
    init(_ value: Any?) {
        self.mValue = value
    }
    
    func to(_ type: Any.Type) -> Any?
    {
        if mValue is NSNull {
            return nil
        }
        
        var value: Any
        if let val = mValue {
            value = val
        } else {
            return nil
        }
        
        if let val = value as? OptionalProtocol {
            if val.isEmpty {
                return nil
            } else {
                value = val.value
            }
        }
        
        if type(of: value) == type {
            return value
        }
        
        var innerType = type
        if let optional = type as? OptionalProtocol.Type {
            innerType = optional.wrappedType()
        }
        
        var string = "\(value)"
        
        if string == "nil" {
            return nil
        }
        
        if string.isEmpty {
            switch innerType {
            case is String.Type:
                break
            default:
                return nil
            }
        }
        
        switch(innerType)
        {
        case is Int.Type, is Int8.Type, is Int16.Type, is Int32.Type, is Int64.Type, is UInt.Type, is UInt8.Type, is UInt16.Type, is UInt32.Type, is UInt64.Type, is NSInteger.Type, is Bool.Type:
            if string.compare("true") == .orderedSame {
                string = "1"
            } else if string.compare("false") == .orderedSame {
                string = "0"
            } else {
                let findIndex: String = "."
                if string.contains(findIndex) {
                    string = string.substring(to: string.range(of: findIndex)!.lowerBound)
                }
            }
            break
        default:
            break
        }
        
        switch(innerType)
        {
        case is Int.Type:
            return Int(string)!
        case is Int8.Type:
            return Int8(string)!
        case is Int16.Type:
            return Int16(string)!
        case is Int32.Type:
            return Int32(string)!
        case is Int64.Type:
            return Int64(string)!
        case is UInt.Type:
            return UInt(string)!
        case is UInt8.Type:
            return UInt8(string)!
        case is UInt16.Type:
            return UInt16(string)!
        case is UInt32.Type:
            return UInt32(string)!
        case is UInt64.Type:
            return Int64(string)!
        case is Double.Type:
            return Double(string)!
        case is NSNumber.Type:
            return NSNumber(value: Double(string)!)
        case is NSInteger.Type:
            return NSInteger(string)!
        case is Date.Type:
            return Date(string: string)
        case is NSDate.Type:
            return NSDate(string: string)!
        case is Bool.Type:
            let boolString = string.uppercased()
            if boolString == "TRUE" || boolString == "YES"
            {
                return true
            }
            else if boolString == "FALSE" || boolString == "NO"
            {
                return false
            }
            
            let number: NSNumber? = to()
            return Bool.init(number!)
        case is Float.Type:
            return Float(string)!
        case is Float64.Type:
            return Float64(string)!
            //        case is Float80.Type:
        //            return Float80(self)
        case is String.Type:
            if let date = value as? Date {
                let dateFormatter = DateFormatter()
                if Int(date.timeIntervalSince1970) % (24 * 60 * 60) == 0 {
                    dateFormatter.dateFormat = "d MMM yyyy"
                } else {
                    dateFormatter.dateFormat = "d MMM yyyy, h:mm a"
                }
                dateFormatter.locale = NSLocale.current
                return dateFormatter.string(from: date)
            }
            return string
        default:
            return self
        }
    }
    func to<T>() -> T?
    {
        return to(T.self) as? T
    }
    
    func Cast<T>() -> T?
    {
        if mValue == nil {
            return nil
        }
        
        let value = mValue!
        
        if let optional = value as? OptionalProtocol
        {
            if optional.isEmpty
            {
                return nil
            }
            return optional.value as? T
        }
        return value as? T
    }
    
    func toCurrency() -> String {
        return toCurrency(showDecimail: true)
    }
    
    func toCurrency(showDecimail: Bool) -> String {
        if mValue == nil {
            return ""
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.init(identifier: "es_MY")
        formatter.currencySymbol = ""
        formatter.currencyGroupingSeparator = ","
        formatter.currencyDecimalSeparator = "."
        if !showDecimail {
            formatter.maximumFractionDigits = 0
        }
        let number: NSNumber = to()!
        return "RM \(formatter.string(from: number)!)"
    }
    
    func toPHCurrency() -> String {
        if mValue == nil {
            return ""
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = NSLocale(localeIdentifier: "es_PH") as Locale!
        formatter.currencyDecimalSeparator = "."
        formatter.currencyGroupingSeparator = ","
        let number: NSNumber = to()!
        return formatter.string(from: number)!
    }
    
    func countDown() -> String {
        let date: Date = to()!
        
        var different = Int(date.timeIntervalSince(Date()))
        
        let secondsInMilli: Int = 1
        let minutesInMilli = secondsInMilli * 60
        let hoursInMilli = minutesInMilli * 60
        let daysInMilli = hoursInMilli * 24
        
        let elapsedDays = different / daysInMilli
        different = different % daysInMilli
        
        let elapsedHours = different / hoursInMilli
        different = different % hoursInMilli
        
        let elapsedMinutes = different / minutesInMilli
        different = different % minutesInMilli
        
        let elapsedSeconds = different / secondsInMilli
        
        if elapsedDays == 1{
            return "a day"
        }
        else if elapsedDays == -1 {
            return "a day ago"
        }
        else if elapsedDays > 0 {
            return "\(elapsedDays) days"
        }
        else if elapsedDays < 0 {
            //            return Convert(date).to()!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM yyyy"
            dateFormatter.locale = NSLocale.current
            return dateFormatter.string(from: date)
        }
            
        else if elapsedHours == 1 {
            return "an hour"
        }
        else if elapsedHours == -1 {
            return "an hour ago"
        }
        else if elapsedHours > 0 {
            return "\(elapsedHours) hours"
        }
        else if elapsedHours < 0 {
            return "\(-elapsedHours) hours ago"
        }
            
        else if elapsedMinutes == 1 {
            return "a minute"
        }
        else if elapsedMinutes == -1 {
            return "a minute ago"
        }
        else if elapsedMinutes > 0 {
            return "\(elapsedMinutes) minutes"
        }
        else if elapsedMinutes < 0 {
            return "\(-elapsedMinutes) minutes ago"
        }
            
        else if elapsedSeconds > 0 {
            return "few seconds"
        }
        else {
            return "few seconds ago"
        }
    }
}
