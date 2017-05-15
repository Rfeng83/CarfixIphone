//
//  UITextFieldExtension.swift
//  Carfix2
//
//  Created by Re Foong Lim on 13/04/2016.
//  Copyright © 2016 Oneworks Sdn. Bhd. All rights reserved.
//

import Foundation
import UIKit

private var kAssociationKeyNextField: UInt8 = 0
private var kAssociationKeyDoneButton: UInt8 = 1

extension UITextField {
    @IBOutlet
    var nextField: UIView? {
        get {
            return objc_getAssociatedObject(self, &kAssociationKeyNextField) as? UIView
        }
        set(newField) {
            self.returnKeyType = .next
            objc_setAssociatedObject(self, &kAssociationKeyNextField, newField, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    @IBOutlet
    var doneButton: UIView? {
        get {
            return objc_getAssociatedObject(self, &kAssociationKeyDoneButton) as? UIView
        }
        set(button) {
            self.returnKeyType = .done
            objc_setAssociatedObject(self, &kAssociationKeyDoneButton, button, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

extension UITextView {
    @IBOutlet
    var nextField: UIView? {
        get {
            return objc_getAssociatedObject(self, &kAssociationKeyNextField) as? UIView
        }
        set(newField) {
            objc_setAssociatedObject(self, &kAssociationKeyNextField, newField, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    @IBOutlet
    var doneButton: UIView? {
        get {
            return objc_getAssociatedObject(self, &kAssociationKeyDoneButton) as? UIView
        }
        set(button) {
            objc_setAssociatedObject(self, &kAssociationKeyDoneButton, button, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
