//
//  PopupPicker.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 14/12/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class PopupPicker: CustomTextField, BaseTableReturnData
{
    override func initView() -> PopupPicker {
        _ = super.initView()
        return self
    }
    
    override func drawRightView() {
        self.rightView = UIImageView(image: #imageLiteral(resourceName: "ic_play_arrow"))
        let degrees: Double = 90
        let radians: Double = degrees * .pi / 180
        self.rightView?.transform = CGAffineTransform(rotationAngle: CGFloat(radians))
        self.rightView?.tintColor = CarfixColor.gray800.color
        self.rightView?.frame = CGRect(origin: (self.rightView?.frame.origin)!, size: CGSize(width: 16, height: 16))
        self.rightViewMode = .always
    }
    
    func donePicker(hasChanges: Bool) {
        if hasChanges {
            didSelectRow()
        }
        if self.nextField != nil {
            self.nextField?.becomeFirstResponder()
        }
        else if self.doneButton != nil && self.doneButton is UIControl {
            closeTextField()
            (self.doneButton as! UIControl).sendActions(for: .touchUpInside)
        }
        else {
            closeTextField()
        }
    }
    
    func didSelectRow() {
        if let controller = self.delegate as? PopupPickerDelegate {
            if let method = controller.didSelectRow {
                method(self)
            }
        }
    }
    
    var _pickOption: NSArray?
    func setPickOption(arr: NSArray) {
        _pickOption = arr
    }
    func getPickOption() -> NSArray {
        if _pickOption.isEmpty {
            if let controller = self.delegate as? PopupPickerDelegate
            {
                if let getMethod = controller.getPickOption {
                    return getMethod(self)
                }
            }
            return [""]
        }
        else {
            return _pickOption!
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "picker") as! UINavigationController
        let controller = nav.topViewController as! PickerController
        controller.delegate = self
        var items: [BaseTableItem] = []
        for item in getPickOption() {
            if let item = item as? BaseTableItem {
                items.append(item)
            } else {
                items.append(PopupPickerItem(Convert(item).to()))
            }
        }
        controller.options = items
        self.parentViewController?.present(nav, animated: true, completion: nil)
        
        return false
    }
    
    func tableSelection(sender: BaseTableController, section: Int?, row: Int?) {
        var hasChanges = false
        if let row = row {
            let result: String? = Convert(getPickOption()[row]).to()
            if self.text != result {
                hasChanges = true
            }
            self.text = result
        } else {
            self.text = nil
        }
        donePicker(hasChanges: hasChanges)
    }
    
    func selectRow(_ value: String?) {
        var hasChanges = false
        if self.text != value {
            hasChanges = true
        }
        self.text = value
        if hasChanges {
            didSelectRow()
        }
    }
}

@objc
protocol PopupPickerDelegate
{
    @objc optional func getPickOption(_ picker: PopupPicker) -> NSArray
    @objc optional func didSelectRow(_ picker: PopupPicker)
}

class PopupPickerItem: BaseTableItem {
    required init(_ title: String?) {
        super.init()
        self.title = title
    }
}
