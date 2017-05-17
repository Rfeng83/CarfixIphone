//
//  EditProfileController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 14/12/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class EditProfileController: BaseFormController, CustomEditPageDelegate, HasImagePicker {
    @IBOutlet weak var editPage: CustomEditPage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CarFixAPIPost(self).getProfile(onSuccess: { data in
            self.mModel = data?.Result
            self.editPage.refresh()
        })
    }
    
    var mModel: GetProfileResult?
    func buildModel() -> NSObject {
        if let model = self.mModel {
            let profileModel = ProfileModel()
            profileModel.name = model.UserName
            profileModel.email = model.Email
            profileModel.mobile = model.PhoneNo
            profileModel.country = Country.from(code: model.Country)?.rawValue
            return profileModel
        } else {
            return ProfileModel()
        }
    }
    
    func buildField(name: String, item: BaseTableItem, field: UIView) -> UIView {
        var customField = field as! CustomTextField
        if name == "mobile" || name == "country" {
            customField.isEnabled = false
        }
        else {
            if name == "email" {
                let name = customField.name
                customField = CustomEmailField(frame: customField.frame).initView()
                customField.name = name
            }
            
            customField.isRequired = true
        }
        
        return customField
    }
    
    var profileImage: RoundedImageView!
    
    func beforeDrawing(_ sender: CustomEditPage) {
        let bounds = UIScreen.main.bounds
        let width: CGFloat = 128
        let height: CGFloat = width
        let x: CGFloat = (bounds.width - width) / 2
        let y: CGFloat = 10
        
        let imageView = RoundedImageView(frame: CGRect(x: x, y: y, width: width, height: height)).initView()
        if let imagePath = mModel?.ProfileImage {
            ImageManager.downloadImage(mUrl: imagePath, imageView: imageView)
        } else {
            imageView.image = #imageLiteral(resourceName: "ic_profile_default")
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(imageTapped(img:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        profileImage = imageView
        
        sender.insertSubview(imageView, at: 0)
    }
    
    func afterDrawing(_ sender: CustomEditPage) -> Bool {
        var x: CGFloat = Config.padding
        var y: CGFloat = sender.estimateAdjustedRect().size.height + Config.padding
        let dividerWidth: CGFloat = 10
        
        x = x + Config.fieldLabelWidth + dividerWidth
//        let emailVerificationLink = SmallLabel(frame: CGRect(x: x, y: y, width: UIScreen.main.bounds.size.width, height: Config.lineHeight)).initView()
//        emailVerificationLink.textColor = CarfixColor.primary.color
//        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
//        let underlineAttributedString = NSAttributedString(string: "Email verification link", attributes: underlineAttribute)
//        emailVerificationLink.attributedText = underlineAttributedString
//        sender.addSubview(emailVerificationLink)
//        
//        let notVerifiedText = "Not Verified"
//        let notVerifiedFont = UIFont.italicSystemFont(ofSize: Config.fontSizeSmall)
//        let notVerifiedWidth = notVerifiedText.width(with: Config.lineHeight, font: notVerifiedFont)
//        x = UIScreen.main.bounds.size.width - notVerifiedWidth - Config.padding
//        let notVerifiedLabel = SmallLabel(frame: CGRect(x: x, y: y, width: notVerifiedWidth, height: Config.lineHeight)).initView()
//        notVerifiedLabel.textColor = CarfixColor.gray700.color
//        notVerifiedLabel.text = notVerifiedText
//        notVerifiedLabel.font = notVerifiedFont
//        sender.addSubview(notVerifiedLabel)
        
        x = Config.padding
        y = y + Config.lineHeight + Config.padding
        
        let mandatoryLabel = SmallLabel(frame: CGRect(x: x, y: y, width: UIScreen.main.bounds.size.width, height: Config.lineHeight)).initView()
        let text: NSMutableAttributedString = NSMutableAttributedString.init(string: "* - mandatory fields")
        text.addAttributes([NSForegroundColorAttributeName: CarfixColor.primary.color], range: NSMakeRange(0, 1))
        mandatoryLabel.attributedText = text
        sender.addSubview(mandatoryLabel)
        
        y = y + Config.lineHeight + Config.padding + Config.margin
        
        let borderWidth: CGFloat = UIScreen.main.bounds.size.width
        let viewHeight: CGFloat = Config.lineHeight + Config.padding * 2 + Config.margin * 2
        
        sender.addSubview(buildBorder(y: y, width: borderWidth))
        
        y = y + 1
        let changePasswordView = UIView(frame: CGRect(x: 0, y: y, width: borderWidth, height: viewHeight))
        sender.addSubview(changePasswordView)
        
        var viewX: CGFloat = Config.padding
        let viewY: CGFloat = Config.padding + Config.margin
        
        let changePasswordImg = CustomImageView(frame: CGRect(x: viewX, y: viewY, width: Config.iconSize, height: Config.iconSize)).initView()
        changePasswordImg.image = #imageLiteral(resourceName: "ic_lock")
        changePasswordImg.tintColor = CarfixColor.gray800.color
        changePasswordView.addSubview(changePasswordImg)
        viewX = viewX + Config.iconSize + Config.padding
        let changePasswordLabel = CustomLabel(frame: CGRect(x: viewX, y: viewY, width: borderWidth, height: Config.lineHeight)).initView()
        changePasswordLabel.text = "Change Password"
        changePasswordView.addSubview(changePasswordLabel)
        
        y = y + changePasswordView.bounds.size.height
        
        sender.addSubview(buildBorder(y: y, width: borderWidth))
        
        let changePasswordGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(changePassword))
        changePasswordView.isUserInteractionEnabled = true
        changePasswordView.addGestureRecognizer(changePasswordGestureRecognizer)

        
//        y = y + 1
//        let paymentMethodView = UIView(frame: CGRect(x: 0, y: y, width: borderWidth, height: viewHeight))
//        sender.addSubview(paymentMethodView)
//        
//        viewX = Config.padding
//        
//        let paymentMethodImg = CustomImageView(frame: CGRect(x: viewX, y: viewY, width: Config.iconSize, height: Config.iconSize)).initView()
//        paymentMethodImg.image = #imageLiteral(resourceName: "ic_credit_card")
//        paymentMethodImg.tintColor = CarfixColor.gray800.color
//        paymentMethodView.addSubview(paymentMethodImg)
//        viewX = viewX + Config.iconSize + Config.padding
//        let paymentMethodLabel = CustomLabel(frame: CGRect(x: viewX, y: viewY, width: borderWidth, height: Config.lineHeight)).initView()
//        paymentMethodLabel.text = "Payment Method"
//        paymentMethodView.addSubview(paymentMethodLabel)
//        
//        y = y + paymentMethodView.bounds.size.height
//        
//        sender.addSubview(buildBorder(y: y, width: borderWidth))
        
        return true
    }
    
    func changePassword() {
        performSegue(withIdentifier: Segue.segueChangePassword.rawValue, sender: self)
    }
    
    func buildBorder(y: CGFloat, width: CGFloat) -> UIView {
        let borderHeight: CGFloat = 1
        
        let borderView = UIView(frame: CGRect(x: 0, y: y, width: width, height: borderHeight))
        borderView.backgroundColor = CarfixColor.gray300.color
        return borderView
    }

    func imageTapped(img: RoundedImageView) {
        self.cameraOrPhoto(sender: img)
    }
    
    func imagePickerPreferredContentSize() -> CGSize {
        return CGSize(width: Config.profileImageWidth, height: Config.profileImageWidth)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var myImageName: String
        
        let uuid = NSUUID()
        myImageName = uuid.uuidString + ".JPEG"
        
        if let imagePath = ImageManager.fileInDocumentsDirectory(filename: myImageName) {
            if let image: UIImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                if ImageManager.saveImage(image: image, path: imagePath.absoluteString) {
                    loadImage(path: myImageName)
                } else {
                    print("failed to save image")
                }
            } else { print("some error message") }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    var newImagePath: String?
    func loadImage(path: String){
        newImagePath = path
        profileImage?.image = ImageManager.loadImageFromPath(path: ImageManager.fileInDocumentsDirectory(filename: path)?.path)
    }
    
    @IBAction func save(_ sender: Any) {
        if editPage.validateFields() {
            if let model = editPage.getResult() as? ProfileModel {
                CarFixAPIPost(self).updateProfile(name: model.name!, email: model.email!, onSuccess: { data in
                    
                    if let imagePath = self.newImagePath {
                        let imageUrl = ImageManager.fileInDocumentsDirectory(filename: imagePath)!
                        let imageForUpload = ImageManager.loadImageFromPath(path: imageUrl.path)!
                        
                        if let mobile = model.mobile {
                            CarFixAPIPost(self).uploadImages(folder: "Profile", key: nil, images: ["\(mobile).jpg" : imageForUpload], onSuccess: { data in
                                
                                if !ImageManager.deleteImage(path: imagePath) {
                                    print("Failed to delete image from devices")
                                }
                                
                                if let downloadPath = data?.Result?.downloadPath {
                                    ImageManager.downloadImage(mUrl: downloadPath, imageView: self.profileImage, cache: false, onSuccess: { data in
                                        
                                        self.message(content: "Save Successfully", dismissView: true)
                                    })
                                }
                            })
                        }
                    }
                    else {
                        self.message(content: "Save Successfully", dismissView: true)
                    }
                })
            }
        } else {
            self.message(content: "Please enter required data to continue")
        }
    }
    
    class ProfileModel: NSObject {
        var country: String?
        var mobile: String?
        var name: String?
        var email: String?
    }
}
