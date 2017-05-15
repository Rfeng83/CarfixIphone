//
//  CustomPicker.swift
//  Carfix
//
//  Created by Re Foong Lim on 10/03/2016.
//  Copyright © 2016 Re Foong Lim. All rights reserved.
//

import Foundation
import UIKit

class CustomDatePicker: CustomTextField
{
    override func initView() -> CustomDatePicker {
        _ = super.initView()
        
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.backgroundColor = CarfixColor.white.color
        picker.addTarget(self, action: #selector(CustomDatePicker.datePickerValueChanged), for: .valueChanged)
        
        self.inputView = picker
        
        self.rightView = UIImageView(image: #imageLiteral(resourceName: "ic_date_range"))
        self.rightViewMode = .always
        
        return self
    }
    
    func datePickerValueChanged(sender: UIDatePicker){
        //        self.text = sender.date.dateByAddingTimeInterval(0).Convert()
        self.text = sender.date.toDateString()
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
                datePickerValueChanged(sender: picker)
            } else {
                self.text = nil
            }
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        let picker = self.inputView as! UIDatePicker
        if let date: Date = Convert(self.text).to() {
            picker.date = date
        }
        else {
            datePickerValueChanged(sender: picker)
        }
        
        return super.becomeFirstResponder()
    }
}

protocol CustomDatePickerDelegate: UITextFieldDelegate
{
    func customDatePickerChanged(picker: UIDatePicker)
}
