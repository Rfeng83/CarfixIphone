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
    
    @IBOutlet weak var scrollViewBottom: NSLayoutConstraint?
    var scrollView: UIScrollView?
    var scrollViewRect: CGRect?
    var keyboardSize: CGSize?
    // Called when the UIKeyboardDidShowNotification is sent.
    func keyboardWillBeShown(sender: Notification) {
        let info = sender.userInfo!
        let value = info[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        keyboardSize = value.cgRectValue.size
        updateScrollViewRect()
    }
    
    func getSuperScrollView(view: UIView?) -> UIScrollView? {
        if let view = view {
            if view is UIScrollView {
                guard view is UITextView else {
                    return view as? UIScrollView
                }
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
        
        self.scrollViewBottom?.constant = Config.padding
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
    
    public func textViewDidChange(_ textView: UITextView) {
        updateScrollViewRect()
    }
    
    func updateScrollViewRect() {
        if let keyboardSize = keyboardSize {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                if let activeTextField = self.activeTextField {
                    self.scrollView = self.getSuperScrollView(view: activeTextField)
                    if let view = self.scrollView {
                        let bottomHeight = view.estimateAdjustedRect().height + keyboardSize.height - UIScreen.main.bounds.height + Config.padding * 2
                        self.scrollViewBottom?.constant = bottomHeight
                        
                        var aRect: CGRect
                        
                        if self.scrollViewRect.isEmpty {
                            aRect = view.frame
                            self.scrollViewRect = aRect
                        } else {
                            aRect = self.scrollViewRect!
                        }
                        
                        let keyboardMaxY = UIScreen.main.bounds.maxY - keyboardSize.height
                        let scrollViewExtraHeight = aRect.maxY - keyboardMaxY
                        
                        aRect.size.height = aRect.size.height - scrollViewExtraHeight
                        view.frame = aRect
                        
                        var rc = activeTextField.bounds
                        rc = activeTextField.convert(rc, to: view)
                        self.scrollView?.scrollRectToVisible(rc, animated: false)
                    }
                }
            }
        }
    }
    
    func animateViewMoving(up: Bool, moveValue: CGFloat){
        let movementDuration: TimeInterval = 0.3
        let movement = up ? -moveValue : moveValue
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
}
