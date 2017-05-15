//
//  ViewProfileController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 24/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class ViewProfileController: ViewPageController {
    
    var mModel: GetProfileResult?
    override func refresh() {
        CarFixAPIPost(self).getProfile(onSuccess: { data in
            self.mModel = data?.Result
            if let imagePath = data?.Result?.ProfileImage {
                ImageManager.downloadImage(mUrl: imagePath, imageView: self.image)
            } else {
                self.image.image = #imageLiteral(resourceName: "ic_profile_default")
            }
            
            super.refresh()
        })
    }
    
    override func buildModel() -> Any? {
        return ViewProfileModel().tap(block: { item in
            if let model = mModel{
                item.name = model.UserName
                item.email = model.Email
                item.country = Country.from(code: model.Country)?.rawValue
                item.mobile = model.PhoneNo
            }
        })
    }

    @IBAction func signOut(_ sender: Any) {
        let db = CarfixInfo()
        let profile = db.profile
        
        profile.password = ""
        profile.rememberMe = false
        db.save()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editDetails(_ sender: Any) {
    }
    
    class ViewProfileModel: Tap {
        public var name: String?
        public var email: String?
        public var country: String?
        public var mobile: String?
    }
}
