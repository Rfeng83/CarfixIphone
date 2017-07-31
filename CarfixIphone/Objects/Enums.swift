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
    case My_Test = "http://203.223.133.13"
    case Ph_Test = "http://203.223.133.13/CarfixPh"
    case My = "http://www.carfix.my"
    case Ph = "http://www.carfix.ph"
}

enum CarfixColor: Int {
    case primary = 0xEC5454
    case primaryDark = 0xA90F15
    case green = 0x69BA6D
    case accent = 0xFDA639
    case gray100 = 0xF5F5F5
    case gray200 = 0xEEEEEE
    case gray300 = 0xEDEDED
    case gray500 = 0x999999
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
    case segueNewClaimMap
    case seguePanelWorkshops
    case segueNewClaimResult
    case segueViewWindscreen
    case segueViewClaim
    case segueViewSubmission
    case segueClaimPolicy
    case segueClaimMenu
    case segueClaimPersonal
    case segueClaimVehicle
    case segueClaimBankDetails
    case segueClaimDocument
    case segueClaimAccidentImages
    case segueClaimSubmit
    case segueSubmissionDocuments
    case segueUploadReply
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
    case Windscreen = 7
    
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
            case .Windscreen:
                return "Windscreen"
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
    case OwnerIC = 13
    case DrivingLicense = 11
    case RegistrationCard = 12
    case PoliceReport = 9
    case LatestBankStatement = 15
    
    var title: String {
        get {
            switch self {
            case .OwnerIC:
                return "Identity Card (front & back)"
            case .RegistrationCard:
                return "RIMV Registration Card"
            default:
                return "\(self)".beautify()
            }
        }
    }
}

//None = 0,
//[Description("My Vehicle Damage")]
//MyVehicleDamage = 1,
//[Description("Other Driver's Vehicle Damage")]
//OtherDriverVehicleDamage = 2,
//[Description("Scene of The Accident")]
//SurroundingPhotos = 3,
//[Description("My Vehicle Photo")]
//MyVehiclePhoto = 4,
//[Description("After Repaired Photo")]
//AfterRepaired = 5,
//[Description("Before Repair")]
//BeforeRepair = 6,
//[Description("Midst of Repair")]
//MidstOfRepair = 7,
//[Description("Tinted of Repair")]
//TintedOfRepair = 8,
//[Description("Police Report")]
//PoliceReport = 9,
//[Description("Invoice")]
//Invoice = 10,
//[Description("Driver's IC & License")]
//DriverIC = 11,
//[Description("Registration Card")]
//RegistrationCard = 12,
//[Description("Owner IC / Business Registration No")]
//OwnerIC = 13,
//[Description("Add More Photo")]
//AddMorePhoto = 14,
//[Description("Latest Bank Statement")]
//BankStatement = 15

enum ClaimContentCategoryEnum: Int {
    case MyDetail = 1
    case VehicleAccidentDetail = 2
    case BankDetail = 3
    case DocumentImage = 4
    case AccidentImage = 5
    case PanelWorkshops = 6
    
    var title: String {
        get {
            switch self {
            case .MyDetail:
                return "Details|Your personal information"
            case .VehicleAccidentDetail:
                return "Vehicle & Accident Details|Vehicle affected and accident particulars"
            case .BankDetail:
                return "E-Payment|Provide your bank details"
            case .DocumentImage:
                return "Documents|Required documentation for processing"
            case .AccidentImage:
                return "Accident Images|Four angle images of your damage vehicle"
            case .PanelWorkshops:
                return "Panel Workshops|Select a Panel Workshop"
            }
        }
    }
}
