//
//  ImageEnum.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 17/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit


enum RootPath: String {
    case My = "http://203.223.133.13"
    case Ph = "http://203.223.133.13/CarfixPh"
//    case My = "http://www.carfix.my"
//    case Ph = "http://www.carfix.ph"
}

enum CarfixColor: Int {
    case primary = 0xEC5454
    case primaryDark = 0xA90F15
    case green = 0x69BA6D
    case accent = 0xFDA639
    case gray100 = 0xF5F5F5
    case gray200 = 0xEEEEEE
    case gray300 = 0xEDEDED
    case gray700 = 0x616161
    case gray800 = 0x424242
    case black = 0x000000
    case white = 0xFFFFFF
    case yellow = 0xFFF44F
    
    case shadow = 0xAAAAAA
    case transparent
    
    var color: UIColor {
        get {
            switch self {
            case .transparent:
                return UIColor.clear
            default:
                return UIColor(netHex: self.rawValue)
            }
        }
    }
}

enum Country: String {
    case my = "Malaysia"
    case ph = "Philippines"
    //case sg = "Singapore"
    
    var code: Int {
        get {
            switch self {
            case .my:
                return 60
            case .ph:
                return 63
                //            case .sg:
                //                return 65
            }
        }
    }
    
    var phoneCode: String {
        get {
            return "+\(code)"
        }
    }
    
    var countryCode: String {
        get {
            switch self {
            case .my:
                return "MY"
            case .ph:
                return "PH"
            }
        }
    }
    
    var icon: UIImage {
        get {
            switch self {
            case .my:
                return #imageLiteral(resourceName: "my")
            case .ph:
                return #imageLiteral(resourceName: "ph")
                //            case .sg:
                //                return 65
            }
        }
    }
    
    static func from(code: Int16) -> Country? {
        switch code {
        case 60:
            return .my
        case 63:
            return .ph
            
        default:
            return .my
        }
    }
}

enum NotificationType: Int16 {
    case Case = 1
    case Claim = 2
    case Other = 3
    
    var title: String {
        get {
            switch self {
            case .Case:
                return "Case"
            case .Claim:
                return "Claim"
            case .Other:
                return "Other"
            }
        }
    }
}

enum ServiceNeeded: Int16 {
    case FuelDelivery = 1
    case TowingServices = 2
    case BatteryChange = 3
    case TyreChange = 4
    case ForemanServices = 5
    case JumpStartServices = 6
    
    static var cases: [ServiceNeeded] {
        get {
            return [.FuelDelivery, .TowingServices, .BatteryChange, .TyreChange, .ForemanServices, .JumpStartServices]
        }
    }
    
    var title: String {
        get {
            return "\(self)".beautify()
        }
    }
    
    var icon: UIImage {
        get {
            switch self {
            case .FuelDelivery:
                return #imageLiteral(resourceName: "ic_fuel_delivery")
            case .TowingServices:
                return #imageLiteral(resourceName: "ic_towing_services")
            case .BatteryChange:
                return #imageLiteral(resourceName: "ic_battery_change")
            case .TyreChange:
                return #imageLiteral(resourceName: "ic_tyre_change")
            case .ForemanServices:
                return #imageLiteral(resourceName: "ic_foreman_services")
            case .JumpStartServices:
                return #imageLiteral(resourceName: "ic_jump_start_services")
            }
        }
    }
}

enum Segue: String {
    case segueLogin
    case segueWeb
    case segueVehicle
    case segueEditVehicle
    case segueEditProfile
    case segueNewCase
    case segueNewCaseResult
    case segueCase
    case segueViewMap
    case segueFilter
    case segueNoPolicy
    case segueNotification
    case segueChangePassword
    case seguePolicy
    case segueViewImage
    case seguePanelWorkshops
    case segueNewClaimResult
    case segueViewClaim
}

enum MyError: Error {
    case InternetError(String)
    case MismatchResposeError(String)
}

enum NewsFeedCategory: String {
    case Promotions
    case NewsAndHighlights
    
    static func from(description: String) -> NewsFeedCategory? {
        for item in EnumManager().array(NewsFeedCategory.self) {
            if item.rawValue.beautify().compare(description) == .orderedSame {
                return item
            }
        }
        return nil
    }
    
    var code: Int32 {
        get {
            switch self {
            case .Promotions:
                return 1
            case .NewsAndHighlights:
                return 2
            }
        }
    }
}

enum OfferService: Int {
    case NoPolicy = 0
    case ValidPolicy = 1
    case ISearch = 2
    case MarketValue = 3
    case VehicleCheck = 4
    case CenturyBattery = 5
    
    var description: String {
        get {
            switch self {
            case .NoPolicy:
                return "No Policy"
            case .ValidPolicy:
                return "Carfix Policy"
            case .ISearch:
                return "I-Search"
            case .MarketValue:
                return "Market Value"
            case .VehicleCheck:
                return "Vehicle Check"
            case .CenturyBattery:
                return "Century Battery"
            }
        }
    }
}

enum VehicleMenu: String {
    case DeletePage = "Delete Vehicle"
    case SetDefault = "Set Default"
    case EditDetails = "Edit Details"
    case UpdateList = "Update List"
    
    var image: UIImage {
        get {
            switch self {
            case .DeletePage:
                return #imageLiteral(resourceName: "ic_delete")
            case .SetDefault:
                return #imageLiteral(resourceName: "ic_bookmark")
            case .EditDetails:
                return #imageLiteral(resourceName: "ic_mode_edit")
            case .UpdateList:
                return #imageLiteral(resourceName: "ic_refresh")
            }
        }
    }
}

enum PhotoCategory: Int16 {
    case DamagedVehicle = 1
    case DrivingLicense = 11
    case PoliceReport = 9
    
    var title: String {
        get {
            return "\(self)".beautify()
        }
    }
}
