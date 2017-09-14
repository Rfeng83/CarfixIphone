//
//  WindscreenPolicyController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 18/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class ClaimPolicyController: BaseFormController {
    var key: String?
    var mModel: GetOfferServicesResult?
    var mVehicle: GetVehiclesResult?
    
    @IBOutlet weak var imgPolicy: CustomImageView!
    @IBOutlet weak var contentView: UIView!
    
//    @IBOutlet weak var viewYes: UIView!
//    @IBOutlet weak var viewNo: UIView!
    
//    var isDriver: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = mModel?.ImageURL {
            ImageManager.downloadImage(mUrl: url, imageView: imgPolicy)
        }
        
//        let gestureYes = UITapGestureRecognizer(target: self, action: #selector(isChecked(_:)))
//        viewYes.isUserInteractionEnabled = true
//        viewYes.addGestureRecognizer(gestureYes)
//        
//        let gestureNo = UITapGestureRecognizer(target: self, action: #selector(isChecked(_:)))
//        viewNo.isUserInteractionEnabled = true
//        viewNo.addGestureRecognizer(gestureNo)
//        
//        checkIt(viewYes)
    }
    
//    func isChecked(_ sender: UIGestureRecognizer) {
//        if let item = sender.view {
//            checkIt(item)
//        }
//    }
//    
//    func checkIt(_ item: UIView) {
//        var imgs: [CustomImageView]
//        
//        imgs = viewYes.getAllViews()
//        for img in imgs {
//            img.image = #imageLiteral(resourceName: "ic_radio_button_unchecked")
//            img.tintColor = CarfixColor.shadow.color
//        }
//        imgs = viewNo.getAllViews()
//        for img in imgs {
//            img.image = #imageLiteral(resourceName: "ic_radio_button_unchecked")
//            img.tintColor = CarfixColor.shadow.color
//        }
//        
//        isDriver = item == viewYes
//        imgs = item.getAllViews()
//        for img in imgs {
//            img.image = #imageLiteral(resourceName: "ic_radio_button_checked")
//            img.tintColor = CarfixColor.primary.color
//        }
//    }
    
    @IBAction func continueWindscreen(_ sender: Any) {
        if let vehicleNo = mVehicle?.VehicleRegNo {
            if let insurerName = mModel?.InsurerName {
                CarFixAPIPost(self).newPendingClaim(vehReg: vehicleNo, claimTypeID: 2, isDriver: true, insurerName: insurerName) { data in
                    if let key = data?.Result?.key {
                        self.performSegue(withIdentifier: Segue.segueClaimMenu.rawValue, sender: key)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let svc: ClaimMenuController = segue.getMainController() {
            if let key = sender as? String {
                svc.key = key
                svc.offerService = self.mModel
                svc.vehicle = self.mVehicle
            }
        }
    }
}
