//
//  ResetPasswordController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 14/12/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class ResetPasswordController: BaseFormController, CustomEditPageDelegate {
    @IBOutlet weak var editPage: CustomEditPage!
    
    func buildModel() -> NSObject {
        return PasswordModel()
    }
    
    func buildField(name: String, field: UIView) -> UIView {
        let field = CustomPasswordField(frame: field.frame).initView()
        field.isRequired = true
        return field
    }
    
    func beforeDrawing(_ sender: CustomEditPage) {
        sender.labelWidth = Config.fieldExtraLongLabelWidth
    }
    
    @IBAction func save(_ sender: Any) {
        if editPage.validateFields() {
            if let model = editPage.getResult() as? PasswordModel {
                if model.newPassword != model.confirmPassword {
                    self.message(content: "The New Password and Confirm Password is not matched, please try again")
                    return
                }
                
                let profile = CarfixInfo().profile
//                if profile.password != model.currentPassword {
//                    self.message(content: "Invalid current password, please try again")
//                    return
//                }
                
                MobileUserAPI(self).changePassword(oldPassword: model.currentPassword!, newPassword: model.newPassword!, confirmPassword: model.confirmPassword!, phoneNo: profile.loginID!) { data in
                    if data?.Succeed == true {
                        self.signOut()
                    }
                }
            }
        }
    }
    
    class PasswordModel: NSObject {
        var currentPassword: String?
        var newPassword: String?
        var confirmPassword: String?
    }
}
