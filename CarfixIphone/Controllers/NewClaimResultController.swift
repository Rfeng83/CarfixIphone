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
    var companyName: String?
    var result: NewClaimResult?
    
    @IBOutlet weak var imgLogo: CustomImageView!
    @IBOutlet weak var labelCaseID: CustomLabel!
    @IBOutlet weak var labelEmail: ExtraBigLabel!
    @IBOutlet weak var labelPhone: ExtraBigLabel!
    @IBOutlet weak var imgPhone: CustomImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let result = result {
            if let image = result.InsurerImage {
                ImageManager.downloadImage(mUrl: image, imageView: imgLogo)
            } else {
                imgLogo.image = #imageLiteral(resourceName: "ic_appicon")
            }
            labelCaseID.text = "Case ID : \(result.CaseID ?? "######")"
            labelEmail.text = result.InsurerEmail
            labelPhone.text = result.InsurerContact
        }
        
        let gestureLabel = UITapGestureRecognizer(target: self, action: #selector(callPhone))
        gestureLabel.delegate = self
        labelPhone.isUserInteractionEnabled = true
        labelPhone.addGestureRecognizer(gestureLabel)
        
        let gestureImage = UITapGestureRecognizer(target: self, action: #selector(callPhone))
        gestureImage.delegate = self
        imgPhone.isUserInteractionEnabled = true
        imgPhone.addGestureRecognizer(gestureImage)
    }
    
    func callPhone() {
        if let phoneNo = labelPhone.text {
            self.confirm(content: "Contact \(companyName!)?", handler: {
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
    
    override func viewWillDisappear(_ animated: Bool) {
        dismissParentController(type: BaseTabBarController.self)
    }
}
