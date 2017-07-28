//
//  CustomPicker.swift
//  Carfix
//
//  Created by Re Foong Lim on 10/03/2016.
//  Copyright © 2016 Re Foong Lim. All rights reserved.
//

import Foundation
import UIKit

class CustomTimePicker: CustomTextField
{
    override func initView() -> CustomTimePicker {
        _ = super.initView()
        
        let picker = UIDatePicker()
        
        picker.backgroundColor = CarfixColor.white.color
        picker.addTarget(self, action: #selector(CustomTimePicker.timePickerValueChanged), for: .valueChanged)
        picker.datePickerMode = .time
        
        self.inputView = picker
        
        self.rightView = UIImageView(image: #imageLiteral(resourceName: "ic_access_time"))
        self.rightViewMode = .always
        
        return self
    }
    
    func timePickerValueChanged(sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = NSLocale.current
        self.text = dateFormatter.string(from: sender.date)
        
        if self.delegate is CustomTimePickerDelegate {
            (self.delegate as! CustomTimePickerDelegate).customTimePickerChanged(picker: sender)
        }
    }
    var date: Date? {
        get {
            if let text = self.text {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                return dateFormatter.date(from: text)
            }
            return nil
        }
        set(value) {
            let picker = self.inputView as! UIDatePicker
            if value != nil {
                picker.date = value!
                timePickerValueChanged(sender: picker)
            } else {
                self.text = nil
            }
        }
    }
    
    override func doneTextField() {
        self.date = (self.inputView as! UIDatePicker).date
        super.doneTextField()
    }
    
    override func becomeFirstResponder() -> Bool {
        let picker = self.inputView as! UIDatePicker
        if let date = date {
            picker.date = date
        }
        else {
            timePickerValueChanged(sender: picker)
        }
        
        return super.becomeFirstResponder()
    }
}

protocol CustomTimePickerDelegate: UITextFieldDelegate
{
    func customTimePickerChanged(picker: UIDatePicker)
}
