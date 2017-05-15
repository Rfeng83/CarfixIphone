//
//  CustomPicker.swift
//  Carfix
//
//  Created by Re Foong Lim on 10/03/2016.
//  Copyright © 2016 Re Foong Lim. All rights reserved.
//

import Foundation
import UIKit

class CustomDateTimePicker: CustomTextField
{
    override func initView() -> CustomDateTimePicker {
        _ = super.initView()
        
        let picker = UIDatePicker()
        
        picker.backgroundColor = CarfixColor.white.color
        picker.addTarget(self, action: #selector(CustomDateTimePicker.dateTimePickerValueChanged), for: .valueChanged)
        picker.maximumDate = Date()
        
        self.inputView = picker
        
        self.rightView = UIImageView(image: #imageLiteral(resourceName: "ic_access_time"))
        self.rightViewMode = .always
        
        return self
    }
    
    func dateTimePickerValueChanged(sender: UIDatePicker){
        self.text = Convert(sender.date).to()
        if self.delegate is CustomDatePickerDelegate
        {
            (self.delegate as! CustomDatePickerDelegate).customDatePickerChanged(picker: sender)
        }
    }
    var date: Date? {
        get {
            return Convert(self.text).to()
        }
        set(value) {
            let picker = self.inputView as! UIDatePicker
            if value != nil {
                picker.date = value!
                dateTimePickerValueChanged(sender: picker)
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
        if let date: Date = Convert(self.text).to() {
            picker.date = date
        }
        else {
            dateTimePickerValueChanged(sender: picker)
        }
        
        return super.becomeFirstResponder()
    }
}

protocol CustomDateTimePickerDelegate: UITextFieldDelegate
{
    func customDateTimePickerChanged(picker: UIDatePicker)
}
