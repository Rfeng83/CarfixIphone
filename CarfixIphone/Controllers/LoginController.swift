//
//  LoginController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 25/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Firebase
import FacebookCore
import FacebookLogin

class LoginController: BaseFormController, CustomPickerDelegate {
    //    @IBOutlet weak var labelRememberMe: UIView!
    @IBOutlet weak var labelVersion: CustomLabel!
    @IBOutlet weak var labelRememberMe: CustomLabel!
    @IBOutlet weak var chkRememberMe: UIImageView!
    @IBOutlet weak var chkRememberMeWidth: NSLayoutConstraint!
    
    @IBOutlet weak var viewFacebook: UIView!
    
    @IBOutlet weak var labelForgetPassword: CustomLabel!
    
    @IBOutlet weak var pickCountryLength: NSLayoutConstraint!
    @IBOutlet weak var pickCountry: CountryPicker!
    @IBOutlet weak var txtMobileNumber: CustomPhoneField!
    @IBOutlet weak var txtPassword: CustomPasswordField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        labelVersion.text = "CarFix version \(String(describing: version.value))"
        
        self.view.backgroundColor = UIColor.clear
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        
        labelRememberMe.textColor = CarfixColor.white.color
        chkRememberMeWidth.constant = Config.boxSize
        
        let tapLabelRememberMe = UITapGestureRecognizer(target: self, action: #selector(LoginController.rememberMe))
        labelRememberMe.isUserInteractionEnabled = true
        labelRememberMe.addGestureRecognizer(tapLabelRememberMe)
        
        let tapChkRememberMe = UITapGestureRecognizer(target: self, action: #selector(LoginController.rememberMe))
        chkRememberMe.isUserInteractionEnabled = true
        chkRememberMe.addGestureRecognizer(tapChkRememberMe)
        
        rememberMe(sender: tapChkRememberMe)
        
        let tapForgetPassword = UITapGestureRecognizer(target: self, action: #selector(LoginController.forgetPassword))
        labelForgetPassword.isUserInteractionEnabled = true
        labelForgetPassword.addGestureRecognizer(tapForgetPassword)
        
        pickCountry.underlineOnly = false
        txtMobileNumber.underlineOnly = false
        txtPassword.underlineOnly = false
        
        pickCountry.selectRow(Country.my.phoneCode)
        switch DisplayManager.typeIsLike {
        case .iphone6:
            pickCountryLength.constant = 68
            break
        case .iphone6plus:
            pickCountryLength.constant = 70
            break
        default:
            pickCountryLength.constant = 65
            break
        }
        
        loginButton = LoginButton(readPermissions: [.publicProfile, .email])
        viewFacebook.addSubview(loginButton!)
    }
    
    var loginButton: LoginButton?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loginButton?.frame = CGRect(origin: CGPoint(x: viewFacebook.frame.width - loginButton!.frame.width, y: 0), size: loginButton!.frame.size)
        
        let db = CarfixInfo()
        let profile = db.profile
        
        if let loginID = profile.loginID {
            var mobileNo = loginID
            var code: String = Convert(Country.my.code).to()!
            if loginID.hasPrefix(code) {
                mobileNo = loginID.substring(from: code.endIndex)
                pickCountry.selectRow(Country.my.phoneCode)
            }
            code = Convert(Country.ph.code).to()!
            if loginID.hasPrefix(code) {
                mobileNo = loginID.substring(from: code.endIndex)
                pickCountry.selectRow(Country.ph.phoneCode)
            }
            
            txtMobileNumber.text = mobileNo
            //            _ = txtPassword.becomeFirstResponder()
        }
        txtPassword.text = ""
        
        txtMobileNumber.resignFirstResponder()
        
        if profile.rememberMe {
            if profile.loginID.hasValue && profile.password.hasValue {
                CarFixAPIPost(self).getProfile(onSuccess: { data in
                    if let country = data?.Result?.Country {
                        db.profile.countryCode = country
                        db.save()
                    }
                    self.performSegue(withIdentifier: Segue.segueLogin.rawValue, sender: self)
                })
            }
            
            if AccessToken.current.hasValue {
                loadFacebookData()
            }
        }
    }
    
    func loadFacebookData()
    {
        let connection = GraphRequestConnection()
        var request = GraphRequest(graphPath: "/me")
        request.parameters = ["fields": "id, name, email, picture.type(large)"]
        connection.add(request) { resp, result in
            switch result {
            case .success(let response):
                print(response)
                if let id = response.dictionaryValue?["id"] {
                    print(id)
                }
                if let name = response.dictionaryValue?["name"] {
                    print(name)
                }
                if let email = response.dictionaryValue?["email"] {
                    print(email)
                }
            case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
            }
        }
        connection.start()
        
        //        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email, picture.type(large)"])
        //        graphRequest.start({ (response, result) in
        //            guard let email = result["email"] as? String else {
        //                return
        //            }
        ////            let name = result["name"]
        ////            let picture = result["picture"]
        //            print(email)
        //        })
        
        //        graphRequest.start({ (connection, result, error) -> Void in
        //            if ((error) != nil)
        //            {
        //                // Process error
        //                print("Error: \(error)")
        //            }
        //            else
        //            {
        //                print(result)
        //
        //            }
        //        })
    }
    
    var isRememberMe: Bool! = false
    func rememberMe(sender: UITapGestureRecognizer) {
        isRememberMe = !isRememberMe
        if isRememberMe == true {
            chkRememberMe.tintColor = CarfixColor.accent.color
            chkRememberMe.image = #imageLiteral(resourceName: "ic_check_box").withRenderingMode(.alwaysTemplate)
        } else {
            chkRememberMe.tintColor = CarfixColor.gray800.color
            chkRememberMe.image = #imageLiteral(resourceName: "ic_check_box_outline_blank").withRenderingMode(.alwaysTemplate)
        }
    }
    
    func didSelectRow(_ picker: CustomPicker) {
        if let countryText = picker.text {
            if let country = Country(rawValue: countryText) {
                picker.text = "+\(country.code)"
            }
        }
    }
    
    @IBAction func login(_ sender: Any) {
        if pickCountry.text.isEmpty != false {
            self.message(content: "Country code is required")
        } else if txtMobileNumber.text.isEmpty != false {
            self.message(content: "Mobile Number is required")
        } else if txtPassword.text.isEmpty != false {
            self.message(content: "Password is required")
        } else {
            if let country = Country.from(code: Convert(pickCountry.text).to()!) {
                let db = CarfixInfo()
                let profile = db.profile
                var mobilePhone: String = txtMobileNumber.text!
                if String(mobilePhone.characters.first!) == "0"{
                    mobilePhone.remove(at: mobilePhone.startIndex)
                }
                profile.loginID = "\(country.code)\(mobilePhone)"
                profile.password = txtPassword.text
                profile.rememberMe = isRememberMe
                db.save()
                
                CarFixAPIPost(self).getProfile(onSuccess: { data in
                    if let result = data?.Result {
                        if result.PhoneNo.isEmpty == false {
                            profile.countryCode = result.Country
                            db.save()
                            
                            if let phoneToken = InstanceID.instanceID().token() {
                                print("Token from instance: \(phoneToken)")
                                print("Token saved: \(profile.phoneToken ?? "")")
                                CarFixAPIPost(self).updateFirebase(token: phoneToken, isIOS: true) { _ in
                                    
                                }
                            }
                            
                            self.performSegue(withIdentifier: Segue.segueLogin.rawValue, sender: self)
                        } else {
                            self.message(content: "Invalid mobile no./password")
                        }
                    }
                })
            }
        }
    }
    
    func forgetPassword(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: Segue.segueWeb.rawValue, sender: "Forget Password")
    }
    
    @IBAction func registerHere(_ sender: Any) {
        performSegue(withIdentifier: Segue.segueWeb.rawValue, sender: "Registration")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController {
            if let vc = nav.topViewController as? WebController {
                let title: String = Convert(sender).to()!
                let baseURL = RootPath.My.rawValue
                
                switch title {
                case "Registration":
                    vc.url = URL(string: "\(baseURL)/MobileUser/RegisterMobileUser")!
                    break
                default:
                    vc.url = URL(string: "\(baseURL)/MobileUser/ResetMobileUserPassword")!
                    break
                }
                vc.title = title
            }
        }
    }
}
