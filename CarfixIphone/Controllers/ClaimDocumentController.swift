//
//  ClaimDocumentController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 28/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class ClaimDocumentController: ClaimImagesController {
    @IBOutlet weak var viewPoliceReport: UIView!
    @IBOutlet weak var viewPoliceReportHeight: NSLayoutConstraint!
    @IBOutlet weak var viewIC: UIView!
    @IBOutlet weak var viewICHeight: NSLayoutConstraint!
    @IBOutlet weak var viewDrivingLicense: UIView!
    @IBOutlet weak var viewDrivingLicenseHeight: NSLayoutConstraint!
    @IBOutlet weak var viewRIMV: UIView!
    @IBOutlet weak var viewRIMVHeight: NSLayoutConstraint!
    @IBOutlet weak var viewBankStatement: UIView!
    @IBOutlet weak var viewBankStatementHeight: NSLayoutConstraint!
    
    override func redrawImages() {
        self.drawImageUpload(category: .PoliceReport)
        self.drawImageUpload(category: .OwnerIC)
        self.drawImageUpload(category: .DrivingLicense)
        self.drawImageUpload(category: .RegistrationCard)
        self.drawImageUpload(category: .LatestBankStatement)
    }    
    
    override func getImageContainer(category: PhotoCategory) -> UIView? {
        switch category {
        case .OwnerIC:
            return self.viewIC
        case .DrivingLicense:
            return self.viewDrivingLicense
        case .PoliceReport:
            return self.viewPoliceReport
        case .RegistrationCard:
            return self.viewRIMV
        case .LatestBankStatement:
            return self.viewBankStatement
        default:
            return nil
        }
    }
    
    override func getImageContainerHeight(category: PhotoCategory) -> NSLayoutConstraint? {
        switch category {
        case .OwnerIC:
            return self.viewICHeight
        case .DrivingLicense:
            return self.viewDrivingLicenseHeight
        case .PoliceReport:
            return self.viewPoliceReportHeight
        case .RegistrationCard:
            return self.viewRIMVHeight
        case .LatestBankStatement:
            return self.viewBankStatementHeight
        default:
            return nil
        }
    }
    
    override func existsImageRemovable() -> Bool {
        return true
    }
}
