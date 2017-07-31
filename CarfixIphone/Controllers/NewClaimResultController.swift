//
//  NewClaimResultController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 11/05/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class NewClaimResultController: BaseFormController, UIGestureRecognizerDelegate {
    var key: String?
    
    @IBOutlet weak var imgLogo: CustomImageView!
    @IBOutlet weak var labelCaseID: CustomLabel!
    @IBOutlet weak var labelEmail: ExtraBigLabel!
    @IBOutlet weak var labelPhone: ExtraBigLabel!
    @IBOutlet weak var imgPhone: CustomImageView!
    @IBOutlet weak var imgEmail: CustomImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureLabel = UITapGestureRecognizer(target: self, action: #selector(callPhone))
        gestureLabel.delegate = self
        labelPhone.isUserInteractionEnabled = true
        labelPhone.addGestureRecognizer(gestureLabel)
        
        let gestureImage = UITapGestureRecognizer(target: self, action: #selector(callPhone))
        gestureImage.delegate = self
        imgPhone.isUserInteractionEnabled = true
        imgPhone.addGestureRecognizer(gestureImage)
        
        imgEmail.image = #imageLiteral(resourceName: "ic_email").withRenderingMode(.alwaysTemplate)
        imgEmail.tintColor = CarfixColor.primary.color
        imgPhone.image = #imageLiteral(resourceName: "ic_phone").withRenderingMode(.alwaysTemplate)
        imgPhone.tintColor = CarfixColor.primary.color
        
        refresh()
    }
    
    var mResult: GetClaimResult?
    func refresh() {
        if let key = key {
            CarFixAPIPost(self).getClaim(key: key) { data in
                self.mResult = data?.Result
                if let result = self.mResult {
                    if let image = result.InsurerImage {
                        ImageManager.downloadImage(mUrl: image, imageView: self.imgLogo)
                    } else {
                        self.imgLogo.image = #imageLiteral(resourceName: "ic_appicon")
                    }
                    self.labelCaseID.text = "Case ID : \(result.CaseID)"
                    self.labelEmail.text = result.InsurerEmail
                    self.labelPhone.text = result.InsurerContact
                }
            }
        }
    }
    
    func callPhone() {
        if let phoneNo = labelPhone.text {
            if let companyName = mResult?.InsurerName {
                self.confirm(content: "Contact \(companyName)?", handler: {
                    data in
                    
                    if let url = URL(string: "tel://\(phoneNo)") {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            // Fallback on earlier versions
                            UIApplication.shared.openURL(url)
                        }
                    }
                })
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dismissParentController(type: BaseTabBarController.self)
    }
}
