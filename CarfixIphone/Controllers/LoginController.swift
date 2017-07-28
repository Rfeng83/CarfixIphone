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

class LoginController: BaseFormController, CustomPickerDelegate, LoginButtonDelegate {
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
        loginButton?.delegate = self
        viewFacebook.addSubview(loginButton!)
        
        LoginController.facebookReadySignedIn = AccessToken.current.hasValue
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
    }
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
    }
    
    var loginButton: LoginButton?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            CarFixAPIPost(self).checkVersion(ver: version) { data in
                if let result = data?.Result {
                    if result.needUpdate == 1 {
                        self.message(content: "Latest version (\(result.latestVersion!)) was ready, please download it from AppStore to continue", handler: { data in
                            UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/app/id\(Config.appStoreID)")!)
                        })
                    } else {
                        self.initLogin()
                    }
                }
            }
        } else {
            initLogin()
        }
    }
    
    func resizeFacebookButton() {
        loginButton?.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: viewFacebook.frame.size)
    }
    
    override func viewDidLayoutSubviews() {
        resizeFacebookButton()
    }
    
    func initLogin() {        
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
        } else {
            if AccessToken.current.hasValue {
                self.loadFacebookData()
            } else {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { data in
                    self.loadFacebookData()
                }
            }
        }
    }
    
    static var facebookSigningIn: Bool? = false
    static var facebookReadySignedIn: Bool?
    func loadFacebookData() {
        let connection = GraphRequestConnection()
        var request = GraphRequest(graphPath: "/me")
        request.parameters = ["fields": "id, name, email, picture.type(large)"]
        connection.add(request) { resp, result in
            switch result {
            case .success(let response):
                if let name = response.dictionaryValue?["name"] {
                    if let email = response.dictionaryValue?["email"] {
                        CarFixAPIPost(self).updateFacebook(name: Convert(name).to()!, email: Convert(email).to()!, onSuccess: { data in
                            CarFixAPIPost(self).checkUser(onSuccess: { data in
                                if data?.Result?.IsLoggedIn == 1 {
                                    if LoginController.facebookReadySignedIn == true {
                                        self.performSegue(withIdentifier: Segue.segueLogin.rawValue, sender: self)
                                    } else {
                                        self.startLogin()
                                    }
                                } else {
                                    if LoginController.facebookSigningIn == true {
                                        self.performSegue(withIdentifier: Segue.segueWeb.rawValue, sender: "Facebook")
                                        LoginController.facebookSigningIn = false
                                    } else {
                                        LoginManager().logOut()
                                    }
                                    
                                    self.initLogin()
                                }
                            })
                        })
                    }
                }
            case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
            }
        }
        connection.start()
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
                
                startLogin()
            }
        }
    }
    
    func startLogin() {
        CarFixAPIPost(self).getProfile(onSuccess: { data in
            if let result = data?.Result {
                if result.PhoneNo.isEmpty == false {
                    let db = CarfixInfo()
                    let profile = db.profile
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
                var baseURL = RootPath.My.rawValue
                
                if baseURL.contains("203") {
                    baseURL = "\(baseURL)/CarFix"
                }
                
                switch title {
                case "Registration":
                    vc.title = title
                    vc.url = URL(string: "\(baseURL)/MobileUser/RegisterMobileUser")!
                    break
                case "Facebook":
                    vc.title = "Registration"
                    vc.url = URL(string: "\(baseURL)/MobileUser/RegisterMobileUser?fid=\(AccessToken.current!.userId!)")!
                    break
                default:
                    vc.title = title
                    vc.url = URL(string: "\(baseURL)/MobileUser/ResetMobileUserPassword")!
                    break
                }
            }
        }
    }
}
