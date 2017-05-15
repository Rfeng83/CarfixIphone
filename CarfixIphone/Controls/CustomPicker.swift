//
//  CustomPicker.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 14/12/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class CustomPicker: CustomTextField, UIPickerViewDataSource, UIPickerViewDelegate
{
    
    //    override init(frame: CGRect) {
    //        super.init(frame: frame)
    //        initPicker()
    //    }
    //
    //    required init?(coder aDecoder: NSCoder) {
    //        super.init(coder: aDecoder)
    //        initPicker()
    //    }
    
    override func initView() -> CustomPicker {
        _ = super.initView()
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CustomPicker.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.backgroundColor = CarfixColor.white.color
        picker.showsSelectionIndicator = true
        self.inputView = picker
        self.inputAccessoryView = toolBar
        
        return self
    }
    
    override func drawRightView() {
        let imageView = CustomImageView(frame: CGRect(x: 0, y: 0, width: Config.iconSize, height: Config.iconSize)).initView() //UIImageView(image: #imageLiteral(resourceName: "ic_keyboard_arrow_down"))
        imageView.image = #imageLiteral(resourceName: "ic_keyboard_arrow_down")
        self.rightView = imageView
        self.rightViewMode = .always
    }
    
    func donePicker(hasChanges: Bool) {
        if hasChanges {
            if self.delegate is CustomPickerDelegate {
                if let method = (self.delegate as! CustomPickerDelegate).didSelectRow {
                    method(self)
                }
            }
        }
        if self.nextField != nil
        {
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
    
    var _pickOption: NSArray?
    func setPickOption(arr: NSArray) {
        _pickOption = arr
    }
    func getPickOption() -> NSArray {
        if _pickOption.isEmpty {
            if self.delegate is CustomPickerDelegate
            {
                if let getMethod = (self.delegate as! CustomPickerDelegate).getPickOption {
                    return getMethod(self)
                }
            }
            return [""]
        }
        else {
            return _pickOption!
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return getPickOption().count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let result = getPickOption()[row]
        return Convert(result).to()
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var hasChanges = false
        let result: String? = Convert(getPickOption()[row]).to()
        if self.text != result {
            hasChanges = true
        }
        self.text = result
        donePicker(hasChanges: hasChanges)
    }
    
    override func becomeFirstResponder() -> Bool {
        initToolbar()
        
        //        for option in self.getPickOption() {
        //            let value: String? = Convert(option).to()
        //            if value == self.text {
        //                self.selectRow(self.text)
        //                break
        //            }
        //        }
        
        selectRow(self.text)
        
        return super.becomeFirstResponder()
    }
    
    func selectRow(_ value: String?) {
        var hasChanges = false
        if self.text != value {
            hasChanges = true
        }
        self.text = value
        
        if let picker = self.inputView as? UIPickerView {
            var index = 0
            for option in self.getPickOption() {
                let value: String? = Convert(option).to()
                if value == self.text {
                    break
                }
                index += 1
            }
            
            picker.selectRow(index, inComponent: 0, animated: true)
        }
        donePicker(hasChanges: hasChanges)
    }
}

@objc
protocol CustomPickerDelegate
{
    @objc optional func getPickOption(_ picker: CustomPicker) -> NSArray
    @objc optional func didSelectRow(_ picker: CustomPicker)
}
