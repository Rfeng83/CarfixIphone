//
//  UIViewControllerExtension.swift
//  Carfix2
//
//  Created by Re Foong Lim on 19/04/2016.
//  Copyright © 2016 Oneworks Sdn. Bhd. All rights reserved.
//

import Foundation
import UIKit
import FacebookCore
import FacebookLogin

private var kAssociationKeyMessageFrame: UInt8 = 0

extension UIViewController: UITextFieldDelegate, UITextViewDelegate, NotificationAlertControllerDelegate
{
    open override func awakeFromNib() {
        if let image = getBackgroundImage() {
            self.view.addBackground(image: image)
        }
    }
    
    func getBackgroundImage() -> UIImage? {
        return #imageLiteral(resourceName: "img_background")
    }
    
    var messageFrame: UIView? {
        get {
            return objc_getAssociatedObject(self, &kAssociationKeyMessageFrame) as? UIView
        }
        set(newField) {
            objc_setAssociatedObject(self, &kAssociationKeyMessageFrame, newField, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.nextField != nil
        {
            textField.nextField?.becomeFirstResponder()
        }
        else if textField.doneButton != nil && textField.doneButton is UIControl
        {
            (textField.doneButton as! UIControl).sendActions(for: .touchUpInside)
        }
        else
        {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func help(sender: AnyObject) {
        
        //        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("HelpPageNavView") as! RedNavigationController
        //
        //        let topView =  (vc.topViewController as! ClaimDetailsHelpController)
        //        topView.type  = HelpPage(rawValue: (sender as! UIBarItem).tag.Convert()!)
        //
        //        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func showMenu(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "menu")
        self.present(controller, animated: true, completion: nil)
    }
    
    //    public func textViewDidChange(textView: UITextView) {
    //        let txt = textView as! CustomTextView
    ////        txt.showPlaceholder(txt.text.isEmpty)
    //    }
    
    func alert(content: String) {
        alert(content: content, dismissView: false)
    }
    func alert(content: String, dismissView: Bool){
        let alertController = UIAlertController(title: "Alert", message: content, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            if dismissView {
                if let nav = self.navigationController {
                    if nav.viewControllers.index(of: self) == 0 {
                        self.dismiss(animated: true, completion: nil)
                    }
                    else {
                        nav.popViewController(animated: true)
                    }
                }
            }
        })
        
        alertController.addAction(defaultAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func notification(content: String) {
        notification(content: content, dismissView: false)
    }
    func notification(content: String, dismissView: Bool){
        let alertController = NotificationAlertController(title: "Notification", message: content, preferredStyle: .alert)
        alertController.delegate = self
        
        self.present(alertController, animated: true)
    }
    
    func message(content: String) {
        message(content: content, dismissView: false)
    }
    func message(content: String, dismissView: Bool){
        if dismissView {
            self.message(content: content, handler: { (action: UIAlertAction!) in
                if let nav = self.navigationController {
                    if nav.viewControllers.index(of: self) == 0 {
                        self.dismiss(animated: true, completion: nil)
                    }
                    else {
                        nav.popViewController(animated: true)
                    }
                }
            })
        }
        else {
            self.message(content: content, handler: nil)
        }
    }
    func message(content: String, handler: ((UIAlertAction) -> Void)?){
        let messageController = UIAlertController(title: "Message", message: content, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        messageController.addAction(defaultAction)
        
        DispatchQueue.main.async {
            self.present(messageController, animated: true, completion: nil)
        }
    }
    
    func confirm(content: String, handler: ((UIAlertAction) -> Void)?) {
        confirm(content: content, handler: handler, cancelHandler: nil)
    }
    func confirm(content: String, handler: ((UIAlertAction) -> Void)?, cancelHandler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: "Confirm", message: content, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Yes", style: .default, handler: handler)
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: cancelHandler)
        
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showProgressBar() {
        showProgressBar(msg: "Loading...")
    }
    func showProgressBar(msg: String) {
        DispatchQueue.main.async {
            if self.messageFrame == nil {
                let padding = Config.padding
                let indicatorSize: CGFloat = Config.iconSizeBig
                
                let contentWidth = -padding + UIScreen.main.bounds.width - padding
                
                var x: CGFloat = padding + indicatorSize + padding
                var y: CGFloat = padding
                var width = contentWidth - x - padding
                
                let strLabel = CustomLabel(frame: CGRect(x: x, y: y, width: width, height: Config.lineHeight)).initView()
                strLabel.text = msg
                strLabel.textColor = UIColor.white
                strLabel.numberOfLines = 0
                strLabel.lineBreakMode = .byWordWrapping
                strLabel.textAlignment = .center
                var height = strLabel.fitHeight()
                if height == Config.lineHeight {
                    width = strLabel.fitWidth()
                }
                
                self.messageFrame = UIView(frame: self.view.frame)
                self.messageFrame?.backgroundColor = UIColor(white: 0, alpha: 0.1)
                
                width = width + x + padding
                height = height + padding * 2
                x = self.view.frame.midX - (width / 2)
                y = self.view.frame.midY - height / 2 - padding
                let contentFrame = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
                contentFrame.layer.cornerRadius = Config.lineHeight
                contentFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
                
                x = padding
                y = height / 2 - indicatorSize / 2
                let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
                activityIndicator.frame = CGRect(x: x, y: y, width: indicatorSize, height: indicatorSize)
                activityIndicator.startAnimating()
                contentFrame.addSubview(activityIndicator)
                
                contentFrame.addSubview(strLabel)
                self.messageFrame!.addSubview(contentFrame)
                self.view.addSubview(self.messageFrame!)
            }
        }
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        if let messageFrame = self.messageFrame {
            var fixedFrame = messageFrame.frame;
            fixedFrame.origin.y = scrollView.contentOffset.y + 64
            messageFrame.frame = fixedFrame;
        }
    }
    
    func hideProgressBar()
    {
        DispatchQueue.main.async(execute: {
            if let frame = self.messageFrame {
                frame.removeFromSuperview()
                self.messageFrame = nil
            }
        })
    }
    
    func dismissParentController(type: Any.Type) {
        dismissParentController(svc: self, type: type)
    }
    
    func dismissParentController(svc: UIViewController?, type: Any.Type) {
        if let svc = svc {
            if type(of: svc) == type {
                svc.dismiss(animated: true, completion: nil)
                return
            }
            if let nav = svc as? UINavigationController {
                if let svc = nav.topViewController {
                    if type(of: svc) == type {
                        svc.dismiss(animated: true, completion: nil)
                        return
                    }
                }
            }
            
            dismissParentController(svc: svc.presentingViewController, type: type)
        }
    }
    
    func signOut() {
        if AccessToken.current.isEmpty {
            let db = CarfixInfo()
            let profile = db.profile
            
            profile.password = ""
            profile.rememberMe = false
            db.save()
        } else {
            LoginManager().logOut()
        }
        
        //        self.dismiss(animated: true, completion: nil)
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    //    func getInstructionUrl() -> String? {
    //        return nil
    //    }
    //
    //    func showInstruction() {
    //        if let url = getInstructionUrl() {
    //            if url != "" {
    //                let db = DBHelper()
    //                var instruction: T_Instruction? = db.selectSingle("url = %@", parameters: [url])
    //
    ////                if instruction.isEmpty == false {
    ////                    db.delete(instruction!)
    ////                    instruction = db.selectSingle("url = %@", parameters: [url])
    ////                    db.save()
    ////                }
    //
    //                if instruction.isEmpty || instruction?.isDone == false {
    //                    if let instructionView = self.storyboard!.instantiateViewControllerWithIdentifier("InstructionView") as? InstructionController {
    //                        instructionView.imagePath = url
    //                        self.presentViewController(instructionView, animated: false, completion: nil)
    //                    }
    //
    //                    if instruction.isEmpty {
    //                        let newObject: T_Instruction = db.create()
    //                        instruction = newObject
    //                    }
    //
    //                    instruction?.url = url
    //                    instruction?.isDone = true
    //
    //                    db.save()
    //                }
    //            }
    //        }
    //    }
}
