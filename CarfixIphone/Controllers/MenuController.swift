//
//  MenuController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 19/03/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class MenuController: BaseController {
    
    @IBOutlet weak var labelUserName: BigLabel!
    @IBOutlet weak var labelContactNo: CustomLabel!
    @IBOutlet weak var labelEmail: CustomLabel!
    @IBOutlet weak var labelCountry: CustomLabel!
//    @IBOutlet weak var labelCreditCard: CustomLabel!
    
    @IBOutlet weak var labelVersion: SmallLabel!
    @IBOutlet weak var imgProfile: RoundedImageView!
    @IBOutlet weak var imgEditProfile: UIImageView!
    @IBOutlet weak var imgCaseHistory: UIImageView!
    @IBOutlet weak var imgAbout: UIImageView!
    @IBOutlet weak var imgHelpGuide: UIImageView!
    @IBOutlet weak var imgSettings: UIImageView!
    @IBOutlet weak var imgSignOut: UIImageView!
    
    @IBOutlet weak var btnEditProfile: UIView!
    @IBOutlet weak var btnCaseHistory: UIView!
    @IBOutlet weak var btnAbout: UIView!
    @IBOutlet weak var btnHelp: UIView!
    @IBOutlet weak var btnSetting: UIView!
    @IBOutlet weak var btnSignOut: CustomLabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        labelVersion.text = "Version \(String(describing: version.value))"
        
        CarFixAPIPost(self).getProfile(onSuccess: { data in
            if let result = data?.Result {
                if let image = result.ProfileImage {
                    ImageManager.downloadImage(mUrl: image, imageView: self.imgProfile)
                }
                
                self.labelUserName.text = result.UserName
                self.labelContactNo.text = result.PhoneNo
                self.labelEmail.text = result.Email
                self.labelCountry.text = Country.from(code: result.Country)?.rawValue
//                self.labelCreditCard.text = result.UserName
            }
        })
        
        imgEditProfile.tintColor = CarfixColor.white.color
        imgCaseHistory.tintColor = CarfixColor.white.color
        imgAbout.tintColor = CarfixColor.white.color
        imgHelpGuide.tintColor = CarfixColor.white.color
        imgSettings.tintColor = CarfixColor.white.color
        imgSignOut.tintColor = CarfixColor.white.color
        
        btnEditProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.editProfile(_:))))
        btnCaseHistory.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.caseHistory(_:))))
        btnAbout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.about(_:))))
        btnHelp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.helpGuide(_:))))
        
        btnSignOut.isUserInteractionEnabled = true
        btnSignOut.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.signOut(_:))))
        imgSignOut.isUserInteractionEnabled = true
        imgSignOut.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.signOut(_:))))
    }
    
    func editProfile(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: Segue.segueEditProfile.rawValue, sender: self)
    }
    func caseHistory(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: Segue.segueNotification.rawValue, sender: self)
    }
    func about(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: Segue.segueWeb.rawValue, sender: "About")
    }
    func helpGuide(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: Segue.segueWeb.rawValue, sender: "Help Guide")
    }
    func settings(_ sender: UITapGestureRecognizer) {
        
    }
    
    func signOut(_ sender: UITapGestureRecognizer) {
        super.signOut()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController {
            if let svc = nav.topViewController as? WebController {
                if let title = sender as? String {
                    svc.title = title
                    switch title {
                    case "About":
                        svc.url = URL(string: "http://www.carfix.my/Blog/Pages/ViewPage/12")
                    case "Help Guide":
                        svc.url = URL(string: "http://www.carfix.my/Blog/Pages/ViewPage/17")
                    default: break
                    }
                }
            }
        }
    }
}
