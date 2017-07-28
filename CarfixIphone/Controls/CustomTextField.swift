//
//  CustomTextField.swift
//  Carfix
//
//  Created by Developer on 3/2/16.
//  Copyright © 2016 Re Foong Lim. All rights reserved.
//

import Foundation
import UIKit

class CustomTextField : UITextField, Required {
    override func initView() -> CustomTextField {
        if let font = self.font {
            self.font = font.withSize(Config.editFontSize)
        } else {
            self.font = Config.editFont
        }
        self.backgroundColor = CarfixColor.white.color
        self.tintColor = CarfixColor.gray700.color
        
        return self
    }
    
    override func becomeFirstResponder() -> Bool {
        initToolbar()
        
        return super.becomeFirstResponder()
    }
    
    var name: String?
    
    func initToolbar() {
        var doneButtonLabel = "Next"
        
        var nextField = self.nextField
        while nextField != nil
        {
            if let textField = nextField as? CustomTextField {
                if textField.isEnabled {
                    break
                }
                else {
                    nextField = textField.nextField
                }
            }
            else if let textField = nextField as? CustomTextView {
                if textField.isHidden == false {
                    break
                }
                else {
                    nextField = textField.nextField
                }
            }
        }
        
        if self.doneButton != nil {
            doneButtonLabel = "Done"
        }
        
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(CustomTextField.closeTextField))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let titleItem = UIBarButtonItem(title: self.name, style: .plain, target: self, action: nil)
        titleItem.tintColor = CarfixColor.gray800.color
        
        let doneButton = UIBarButtonItem(title: doneButtonLabel, style: .plain, target: self, action: #selector(CustomTextField.doneTextField))
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = CarfixColor.accent.color
        toolBar.sizeToFit()
        toolBar.setItems([closeButton, spaceButton, titleItem, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.inputAccessoryView = toolBar
    }
    
    public var underlineOnly: Bool = true
    override func draw(_ rect: CGRect) {
        if underlineOnly {
            self.borderStyle = .line
            
            let startingPoint = CGPoint(x: rect.minX, y: rect.maxY)
            let endingPoint = CGPoint(x: rect.maxX, y: rect.maxY)
            
            let path = UIBezierPath()
            
            path.move(to: startingPoint)
            path.addLine(to: endingPoint)
            path.lineWidth = 2.0
            
            tintColor.setStroke()
            
            path.stroke()
        } else {
            super.draw(rect)
        }
        
        drawRightView()
    }
    
    func drawRightView() {
        if self.isEnabled {
            self.rightViewMode = .never
        }
        else {
            let imageView = UIImageView(image: #imageLiteral(resourceName: "ic_lock"))
            imageView.frame = CGRect(x: 0, y: 0, width: Config.lineHeight, height: Config.lineHeight)
            imageView.tintColor = CarfixColor.gray700.color
            self.rightView = imageView
            self.rightViewMode = .always
        }
    }
    
    func closeTextField(){
        self.resignFirstResponder()
    }
    
    func doneTextField() {
        if self.nextField != nil
        {
            if let textField = self.nextField as? CustomTextField {
                if textField.isEnabled == false {
                    closeTextField()
                    textField.doneTextField()
                    return
                }
            }
            else if let textField = self.nextField as? CustomTextView {
                if textField.isHidden {
                    closeTextField()
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
    
    private var mIsRequired: Bool = false
    var isRequired: Bool {
        get {
            return mIsRequired
        }
        set {
            mIsRequired = newValue
            if mIsRequired {
                let placeholder = NSAttributedString(string: "This field is required", attributes: [NSForegroundColorAttributeName : CarfixColor.primary.color])
                self.attributedPlaceholder = placeholder
            } else {
                self.attributedPlaceholder = nil
            }
        }
    }
    
    func validateField() -> Bool {
        return !self.isRequired || !self.text.isEmpty
    }
}

protocol Required {
    var isRequired: Bool{ get set }
}
