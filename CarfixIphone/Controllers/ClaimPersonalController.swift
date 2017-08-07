//
//  ClaimPersonalController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 24/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class ClaimPersonalController: BaseFormController, CustomPickerDelegate {
    var key: String?
    
    @IBOutlet weak var viewPersonalCar: UIView!
    @IBOutlet weak var viewBusinessCar: UIView!
    
    @IBOutlet weak var viewCompanyInfo: UIView!
    @IBOutlet weak var txtCompanyName: CustomTextField!
    @IBOutlet weak var txtCompanyRegNo: CustomTextField!
    @IBOutlet weak var txtGSTNumber: CustomTextField!
    
    @IBOutlet weak var viewOwnerInfo: UIView!
    @IBOutlet weak var txtName: CustomTextField!
    @IBOutlet weak var txtICNo: CustomTextField!
    
    @IBOutlet weak var constraintTelNoToViewCompanyInfo: NSLayoutConstraint!
    @IBOutlet weak var constraintTelNoToViewOwnerInfo: NSLayoutConstraint!
    
    @IBOutlet weak var txtTelNo: CustomTextField!
    @IBOutlet weak var txtMobileNo: CustomTextField!
    @IBOutlet weak var txtEmail: CustomTextField!
    
    @IBOutlet weak var viewDriverYes: UIView!
    @IBOutlet weak var viewDriverNo: UIView!
    
    @IBOutlet weak var viewOtherDriver: UIView!
    @IBOutlet weak var txtDriverName: CustomTextField!
    @IBOutlet weak var txtDriverICNo: CustomTextField!
    @IBOutlet weak var txtDriverTelNo: CustomTextField!
    @IBOutlet weak var txtDriverMobileNo: CustomTextField!
    
    @IBOutlet weak var viewDrivingLicense: UIView!
    //    @IBOutlet weak var viewFullLicense: UIView!
    //    @IBOutlet weak var viewPLicense: UIView!
    
    @IBOutlet weak var txtDrivingLicenseType: CustomPicker!
    @IBOutlet weak var txtDrivingLicenseClass: CustomTextField!
    
    @IBOutlet weak var dateValidityFrom: CustomDatePicker!
    @IBOutlet weak var dateValidityTo: CustomDatePicker!
    
    @IBOutlet weak var viewEverBeenSuspendedYes: UIView!
    @IBOutlet weak var viewEverBeenSuspendedNo: UIView!
    
    @IBOutlet weak var drivingLicenseTopToOtherDriverBottom: NSLayoutConstraint!
    @IBOutlet weak var drivingLicenseTopToIsDriverBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let items = [viewPersonalCar, viewBusinessCar, viewDriverYes, viewDriverNo, viewEverBeenSuspendedYes, viewEverBeenSuspendedNo]
        
        for item in items {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(isChecked(_:)))
            item?.isUserInteractionEnabled = true
            item?.addGestureRecognizer(gesture)
        }
        
        refresh()
        
        DispatchQueue.main.async {
            self.showCompanyInfo(yes: false)
        }
    }
    
    var fullLicense: String = "Full License"
    var pLicense: String = "\"P\" License"
    func getPickOption(_ picker: CustomPicker) -> NSArray {
        return [fullLicense, pLicense]
    }
    
    func refresh() {
        if let key = key {
            CarFixAPIPost(self).getClaimPersonalDetails(key: key) { data in
                if let result = data?.Result {
                    if result.isBusiness == 1 {
                        self.txtCompanyName.text = result.OwnerName
                        self.txtCompanyRegNo.text = result.OwnerIC
                        self.checkIt(self.viewBusinessCar)
                    } else if result.isBusiness == 0 {
                        self.txtName.text = result.OwnerName
                        self.txtICNo.text = result.OwnerIC
                        self.checkIt(self.viewPersonalCar)
                    }
                    
                    self.txtTelNo.text = result.OwnerTel
                    self.txtMobileNo.text = result.OwnerMobile
                    self.txtEmail.text = result.OwnerEmail
                    self.txtGSTNumber.text = result.OwnerGstNo
                    
                    self.txtDriverName.text = result.DriverName
                    self.txtDriverICNo.text = result.DriverIC
                    self.txtDriverTelNo.text = result.DriverTel
                    self.txtDriverMobileNo.text = result.DriverMobile
                    
                    self.txtDrivingLicenseClass.text = result.LicenceClass
                    
                    self.dateValidityFrom.date = result.LicenceIssuedOn
                    self.dateValidityTo.date = result.LicenceExpiredOn
                    
                    if result.isDriverTheOwner == 1 {
                        self.checkIt(self.viewDriverYes)
                    } else if result.isDriverTheOwner == 0 {
                        self.checkIt(self.viewDriverNo)
                    }
                    if result.LicenceType == "P" {
                        self.txtDrivingLicenseType.text = self.pLicense
                    } else if result.LicenceType == "F" {
                        self.txtDrivingLicenseType.text = self.fullLicense
                    }
                    if result.LicenceSuspended == 1 {
                        self.checkIt(self.viewEverBeenSuspendedYes)
                    } else if result.LicenceSuspended == 0 {
                        self.checkIt(self.viewEverBeenSuspendedNo)
                    }
                }
            }
        }
    }
    
    func isChecked(_ sender: UIGestureRecognizer) {
        if let item = sender.view {
            checkIt(item)
        }
    }
    
    func showCompanyInfo(yes: Bool) {
        viewCompanyInfo.isHidden = !yes
        var fields: [UITextField] = viewCompanyInfo.getAllViews()
        for field in fields {
            field.isEnabled = yes
        }
        
        viewOwnerInfo.isHidden = yes
        fields = viewOwnerInfo.getAllViews()
        for field in fields {
            field.isEnabled = !yes
        }
        
        constraintTelNoToViewCompanyInfo.isActive = yes
        constraintTelNoToViewOwnerInfo.isActive = !yes
    }
    
    var isPersonal: Bool?
    var isDriver: Bool?
    //    var isFullLicense: Bool?
    var isEverBeenSuspended: Bool?
    func checkIt(_ item: UIView) {
        var imgs: [CustomImageView]
        
        var viewYes: UIView?
        var viewNo: UIView?
        if item == viewPersonalCar || item == viewBusinessCar {
            viewYes = viewPersonalCar
            viewNo = viewBusinessCar
            isPersonal = item == viewYes
            showCompanyInfo(yes: !isPersonal!)
        }
        else if item == viewDriverYes || item == viewDriverNo {
            viewYes = viewDriverYes
            viewNo = viewDriverNo
            isDriver = item == viewYes
            viewOtherDriver.isHidden = isDriver!
            let fields: [UITextField] = viewOtherDriver.getAllViews()
            for field in fields {
                field.isEnabled = !isDriver!
            }
            drivingLicenseTopToIsDriverBottom.isActive = isDriver!
            drivingLicenseTopToOtherDriverBottom.isActive = !isDriver!
        } else if item == viewEverBeenSuspendedYes || item == viewEverBeenSuspendedNo {
            viewYes = viewEverBeenSuspendedYes
            viewNo = viewEverBeenSuspendedNo
            isEverBeenSuspended = item == viewYes
        }
        
        if let viewYes = viewYes {
            if let viewNo = viewNo {
                imgs = viewYes.getAllViews()
                for img in imgs {
                    img.image = #imageLiteral(resourceName: "ic_radio_button_unchecked")
                    img.tintColor = CarfixColor.shadow.color
                }
                imgs = viewNo.getAllViews()
                for img in imgs {
                    img.image = #imageLiteral(resourceName: "ic_radio_button_unchecked")
                    img.tintColor = CarfixColor.shadow.color
                }
                
                imgs = item.getAllViews()
                for img in imgs {
                    img.image = #imageLiteral(resourceName: "ic_radio_button_checked")
                    img.tintColor = CarfixColor.primary.color
                }
            }
        }
    }
    
    @IBAction func next(_ sender: Any) {
        if isPersonal.isEmpty {
            self.message(content: "Which category is this policy under?")
        } else if isDriver.isEmpty {
            self.message(content: "Were you the driver during the time of accident?")
        } else if isEverBeenSuspended.isEmpty {
            self.message(content: "Have your license ever been suspended or endorsed?")
        }
        
        if let key = key {
            var licenseType: String?
            if let text = txtDrivingLicenseType.text {
                if fullLicense.compare(text) == .orderedSame {
                    licenseType = "F"
                } else if pLicense.compare(text) == .orderedSame {
                    licenseType = "P"
                }
            }
            
            var ownerName: String?
            var ownerIC: String?
            if isPersonal == true {
                ownerName = txtName.text
                ownerIC = txtICNo.text
            } else {
                ownerName = txtCompanyName.text
                ownerIC = txtCompanyRegNo.text
            }
            
            CarFixAPIPost(self).updateClaimPersonalDetails(key: key, OwnerName: ownerName, OwnerIC: ownerIC, OwnerTel: txtTelNo.text, OwnerMobile: txtMobileNo.text, OwnerEmail: txtEmail.text, OwnerGstNo: txtGSTNumber.text, isBusiness: Convert(isPersonal == false).to(), isDriverTheOwner: Convert(isDriver).to(), DriverName: txtDriverName.text, DriverIC: txtDriverICNo.text, DriverTel: txtDriverTelNo.text, DriverMobile: txtDriverMobileNo.text, LicenceType: licenseType, LicenceClass: txtDrivingLicenseClass.text, LicenceExpiredOn: dateValidityTo.date, LicenceIssuedOn: dateValidityFrom.date, LicenceSuspended: Convert(isEverBeenSuspended).to()) { data in
                self.close(sender: self)
            }
        }
    }
    
}
