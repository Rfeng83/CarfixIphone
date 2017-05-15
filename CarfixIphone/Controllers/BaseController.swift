//
//  BaseFormController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 23/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class BaseController: UIViewController {
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK: - Keyboard Management Methods
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self,
                                       selector: #selector(BaseFormController.keyboardWillBeShown(sender:)),
                                       name: .UIKeyboardWillShow,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(BaseFormController.keyboardWillBeHidden(sender:)),
                                       name: .UIKeyboardWillHide,
                                       object: nil)
    }
    
    var scrollView: UIScrollView?
    var scrollViewRect: CGRect?
    // Called when the UIKeyboardDidShowNotification is sent.
    func keyboardWillBeShown(sender: Notification) {
        //let triggerTime = (Int32(NSEC_PER_MSEC) * 10)
        let time = DispatchTime.now() + 0.1
        
        DispatchQueue.main.asyncAfter(deadline: time) {
            //self.keyboardWillBeHidden(sender: sender)
            let info = sender.userInfo!
            let value = info[UIKeyboardFrameBeginUserInfoKey] as! NSValue
            let keyboardSize: CGSize = value.cgRectValue.size
            
            if let activeTextField = self.activeTextField {
                self.scrollView = self.getSuperScrollView(view: activeTextField)
                if let view = self.scrollView {
                    var aRect: CGRect
                    
                    if self.scrollViewRect.isEmpty {
                        aRect = view.frame
                        self.scrollViewRect = aRect
                    } else {
                        aRect = self.scrollViewRect!
                    }
                    
                    let keyboardMaxY = UIScreen.main.bounds.maxY - keyboardSize.height
                    let scrollViewExtraHeight = aRect.maxY - keyboardMaxY
                    
//                    aRect.size.height = aRect.size.height - keyboardSize.height
//                    if !(self is LoginController) {
//                        aRect.size.height = aRect.size.height + activeTextField.frame.size.height + Config.padding * 2
//                    }

                    aRect.size.height = aRect.size.height - scrollViewExtraHeight
                    view.frame = aRect
                    
                    //                    var containerView: UIView = activeTextField
                    //                    var y = containerView.frame.origin.y
                    //                    while !(containerView.superview is UIScrollView) {
                    //                        containerView = containerView.superview!
                    //                        y = containerView.frame.origin.y + y
                    //                    }
                    //                    y = containerView.superview!.frame.origin.y + y
                    //
                    //                    let activeTextFieldRect = activeTextField.frame
                    //                    let activeTextFieldOrigin = activeTextFieldRect.origin
                    //                    let point = CGPoint(x: activeTextFieldOrigin.x, y: y + activeTextFieldRect.height)
                    //                    if !aRect.contains(point) {
                    //                        var offset: CGFloat
                    //                        if self.activeTextField is UITextField {
                    //                            offset = y + activeTextFieldRect.height + 5 + aRect.origin.y - aRect.height
                    //                        }
                    //                        else {
                    //                            offset = y + activeTextFieldRect.height + aRect.origin.y - aRect.height
                    //                        }
                    ////                        self.animateViewMoving(up: true, moveValue: offset)
                    //                    }
                }
            }
        }
    }
    
    func getSuperScrollView(view: UIView?) -> UIScrollView? {
        if let view = view {
            if view is UIScrollView {
                return view as? UIScrollView
            }
            
            return getSuperScrollView(view: view.superview)
        } else {
            return nil
        }
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    func keyboardWillBeHidden(sender: Notification) {
        self.scrollView?.frame = self.scrollViewRect!
        let aRect: CGRect = self.view.frame
        animateViewMoving(up: false, moveValue: -aRect.origin.y)
    }
    
    var activeTextField: UIView?
    func textFieldDidBeginEditing(_ textField: UITextField!) {
        activeTextField = textField
    }
    func textFieldDidEndEditing(_ textField: UITextField!) {
        activeTextField = nil
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextField = textView
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        activeTextField = nil
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration: TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
}
