//
//  CustomTextView.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 17/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class CustomTextView: UITextView {
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        initView()
//    }
//    
//    override init(frame: CGRect, textContainer: NSTextContainer?) {
//        super.init(frame: frame, textContainer: textContainer)
//        initView()
//    }
    
    override func becomeFirstResponder() -> Bool {
        initToolbar()
        return super.becomeFirstResponder()
    }
    
    var placeholder: String {
        get {
            return ""
        }
    }
    
    func initToolbar() {
        
        var doneButtonLabel = "Done"
        
        var nextField = self.nextField
        while nextField != nil
        {
            if let textField = nextField as? CustomTextField {
                if textField.isEnabled {
                    doneButtonLabel = "Next"
                    break
                }
                else {
                    nextField = textField.nextField
                }
            }
            else if let textField = nextField as? CustomTextView {
                if textField.isHidden == false {
                    doneButtonLabel = "Next"
                    break
                }
                else {
                    nextField = textField.nextField
                }
            }
        }
        
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(CustomTextView.closeTextField))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let titleItem = UIBarButtonItem(title: self.placeholder, style: .plain, target: self, action: nil)
        titleItem.tintColor = CarfixColor.gray800.color
        
        let doneButton = UIBarButtonItem(title: doneButtonLabel, style: .plain, target: self, action: #selector(CustomTextView.doneTextField))
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = CarfixColor.accent.color
        toolBar.sizeToFit()
        toolBar.setItems([closeButton, spaceButton, titleItem, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.inputAccessoryView = toolBar
        
    }
    
    func closeTextField(){
        self.resignFirstResponder()
    }
    
    func doneTextField() {
        if self.nextField != nil
        {
            if let textField = self.nextField as? CustomTextField {
                if textField.isEnabled == false {
                    textField.doneTextField()
                    return
                }
            }
            else if let textField = self.nextField as? CustomTextView {
                if textField.isHidden {
                    textField.doneTextField()
                    return
                }
            }
            
            self.nextField?.becomeFirstResponder()
        }
        else if self.doneButton != nil && self.doneButton is UIControl
        {
            closeTextField()
            (self.doneButton as! UIControl).sendActions(for: .touchUpInside)
        }
        else
        {
            closeTextField()
        }
    }
}
