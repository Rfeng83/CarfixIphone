//
//  WindscreenVehicleController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 20/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces

class ClaimVehicleController: BaseFormController, NewClaimMapControllerDelegate {
    var key: String?
    
    //    @IBOutlet weak var txtEngineNo: CustomTextField!
    //    @IBOutlet weak var txtChassisNo: CustomTextField!
    @IBOutlet weak var txtDateAccident: CustomTextField!
    @IBOutlet weak var txtTimeAccident: CustomTextField!
    @IBOutlet weak var txtPlaceAccident: CustomTextView!
    @IBOutlet weak var txtPoliceReportNo: CustomTextField!
    @IBOutlet weak var viewYes: UIView!
    @IBOutlet weak var viewNo: UIView!
    
    //    @IBOutlet weak var txtVehiclePurpose: UITextView!
    //    @IBOutlet weak var txtRoadSide: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureYes = UITapGestureRecognizer(target: self, action: #selector(isChecked(_:)))
        viewYes.isUserInteractionEnabled = true
        viewYes.addGestureRecognizer(gestureYes)
        
        let gestureNo = UITapGestureRecognizer(target: self, action: #selector(isChecked(_:)))
        viewNo.isUserInteractionEnabled = true
        viewNo.addGestureRecognizer(gestureNo)
        
        refresh()
    }
    
    override func textViewDidBeginEditing(_ textView: UITextView) {
        addAddress(UIGestureRecognizer())
    }
    
    func addAddress(_ sender: UIGestureRecognizer) {
        performSegue(withIdentifier: Segue.segueNewClaimMap.rawValue, sender: self)
    }
    
    var mLocation: CLLocation?
    func updateAddressExtra(address: String?, location: CLLocation?, name: String?, zip: String?, city: String?, state: String?, country: String?) {
        txtPlaceAccident.text = address
        mLocation = location
    }
    
    func refresh() {
        if let key = key {
            CarFixAPIPost(self).getClaimVehicle(key: key) { data in
                if let result = data?.Result {
                    //                    self.txtEngineNo.text = result.EngineNo
                    //                    self.txtChassisNo.text = result.ChassisNo
                    if let date = result.DateOfAcc {
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = NSLocale.current
                        dateFormatter.dateFormat = "dd MMM yyyy"
                        self.txtDateAccident.text = dateFormatter.string(from: date)
                        dateFormatter.dateFormat = "h:mm a"
                        self.txtTimeAccident.text = dateFormatter.string(from: date)
                    }
                    self.txtPlaceAccident.text = result.PlaceOfAcc
                    self.txtPoliceReportNo.text = result.PoliceReportNo
                    //                    self.txtVehiclePurpose.text = result.VehiclePurpose
                    //                    self.txtRoadSide.text = result.RoadSide
                    if result.IsInsuredConsent == 1 {
                        self.checkIt(self.viewYes)
                    } else if result.IsInsuredConsent == 0 {
                        self.checkIt(self.viewNo)
                    }
                    
                    if let latitude: Double = Convert(result.AccLatitude).to() {
                        if let longitude: Double = Convert(result.AccLongitude).to() {
                            self.mLocation = CLLocation(latitude: latitude, longitude: longitude)
                        }
                    }
                } else {
                    self.checkIt(self.viewYes)
                }
            }
        }
    }
    
    func isChecked(_ sender: UIGestureRecognizer) {
        if let item = sender.view {
            checkIt(item)
        }
    }
    var isInsuredConsent: Bool?
    func checkIt(_ item: UIView) {
        var imgs: [CustomImageView]
        
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
        
        isInsuredConsent = item == viewYes
        imgs = item.getAllViews()
        for img in imgs {
            img.image = #imageLiteral(resourceName: "ic_radio_button_checked")
            img.tintColor = CarfixColor.primary.color
        }
    }
    
    @IBAction func next(_ sender: Any) {
        if mLocation.isEmpty {
            self.message(content: "Please pick your accident location to continue")
        }
        
        if let key = self.key {
            var dateOfAcc: Date?
            if let text = txtTimeAccident.text {
                if let dateText = txtDateAccident.text {
                    dateOfAcc = Convert("\(dateText), \(text)").to()
                }
            }
            else if let text = txtDateAccident.text {
                dateOfAcc = Convert(text).to()
            }
            
            CarFixAPIPost(self).updateClaimVehicle(key: key, engineNo: nil, chassisNo: nil, dateOfAcc: dateOfAcc, placeOfAcc: txtPlaceAccident.text, policeReportNo: txtPoliceReportNo.text, isInsuredConsent: isInsuredConsent, vehiclePurpose: nil, roadSide: nil, accLatitude: mLocation?.coordinate.latitude, accLongitude: mLocation?.coordinate.longitude) { data in
                self.close(sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let svc: NewClaimMapController = segue.getMainController() {
            svc.delegate = self
            svc.currentLocation = self.mLocation
        }
    }
}
