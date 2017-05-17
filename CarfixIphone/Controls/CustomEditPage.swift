//
//  CustomEditPage.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 14/12/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class CustomEditPage: UIScrollView {
    override func initView() -> CustomEditPage {
        _ = super.initView()
        
        refresh()
        return self
    }
    
    var labelWidth: CGFloat = Config.fieldLabelWidth
    var mFields: Dictionary<String, UIView>!
    func refresh() {
        let baseView: UIView? = self
        baseView!.subviews.forEach({ $0.removeFromSuperview() })
        
        beforeDrawing()
        
        _ = buildModel()
        let items = buildItems()
        
        mFields = [:]
        
        var oriRect = baseView!.estimateAdjustedRect()
        
        var count = 0
        let padding: CGFloat = 8
        let dividerWidth: CGFloat = 10
        let x: CGFloat = padding
        var y: CGFloat = oriRect.height + padding
        let width: CGFloat = UIScreen.main.bounds.width - padding * 2
        let height: CGFloat = Config.fieldHeight
        var prevEdit: CustomTextField?
        for item in items {
            let view = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
            
            let labelText = CustomLabel(frame: CGRect(x: 0, y: 0, width: labelWidth, height: height)).initView()
            labelText.text = item.title
            view.addSubview(labelText)
            
            let labelDivider = CustomLabel(frame: CGRect(x: labelWidth, y: 0, width: dividerWidth, height: height)).initView()
            labelDivider.text = ":"
            view.addSubview(labelDivider)
            
            let valueText = CustomTextField(frame: CGRect(x: labelWidth + dividerWidth, y: 0, width: width - labelWidth - dividerWidth, height: height)).initView()
            valueText.name = item.title
            
            var editControl: UIView?
            if let editPage = self.delegate as? CustomEditPageDelegate {
                if editPage.buildField != nil {
                    editControl = editPage.buildField!(name: item.name, item: item, field: valueText)
                }
            }
            
            if editControl == nil {
                editControl = valueText
            }
            
            if let txt = editControl as? Required {
                if txt.isRequired {
                    _ = labelText.fitWidth()
                    let actualWidth = labelText.frame.size.width
                    let labelRequired = CustomLabel(frame: CGRect(x: actualWidth + 4, y: 0, width: dividerWidth, height: height)).initView()
                    labelRequired.text = "*"
                    labelRequired.textColor = CarfixColor.primary.color
                    view.addSubview(labelRequired)
                }
            }
            
            if let txt = editControl as? CustomTextField {
                txt.text = item.details
                if let parent = self.delegate as? UITextFieldDelegate {
                    txt.delegate = parent
                }
            }
            
            view.addSubview(editControl!)
            
            mFields.updateValue(editControl!, forKey: item.name)
            
            baseView?.insertSubview(view, at: count)
            count += 1
            
            y += (editControl?.frame.height ?? height) + padding
            
            if prevEdit.isEmpty == false {
                prevEdit?.nextField = editControl
            }
            
            if let editText = editControl as? CustomTextField {
                prevEdit = editText
            }
        }
        
        oriRect = baseView!.estimateAdjustedRect()
        
        if afterDrawing() {
            oriRect = baseView!.estimateAdjustedRect()
        }
        
        self.contentSize = CGSize(width: UIScreen.main.bounds.width, height: oriRect.size.height)
    }
    
    func beforeDrawing() {
        if let editPage = self.delegate as? CustomEditPageDelegate {
            if editPage.beforeDrawing != nil {
                editPage.beforeDrawing!(self)
            }
        }
    }
    
    func afterDrawing() -> Bool {
        if let editPage = self.delegate as? CustomEditPageDelegate {
            if editPage.afterDrawing != nil {
                return editPage.afterDrawing!(self)
            }
        }
        return false
    }
    
    func getResult() -> NSObject? {
        if let model = buildModel() {
            let mirror = Mirror(reflecting: model)
            let children = mirror.getAllChildren()
            
            for field in mFields {
                if let child = children[field.key] {
                    if let txt = field.value as? CustomTextField {
                        model.setValue(Convert(txt.text).to(type(of: child)), forKey: field.key)
                    }
                }
            }
            return model
        }
        
        return nil
    }
    
    func validateFields() -> Bool {
        for field in mFields {
            if let txt = field.value as? CustomTextField {
                if !txt.validateField() {
                    return false
                }
            }
        }
        
        return true
    }
    
    var mModel: NSObject?
    func buildModel() -> NSObject? {
        if let editPage = self.delegate as? CustomEditPageDelegate {
            mModel = editPage.buildModel()
        } else {
            mModel = nil
        }
        return mModel
    }
    func getModel() -> NSObject? {
        if let model = self.mModel {
            return model
        } else {
            return buildModel()
        }
    }
    
    func buildItems() -> [BaseTableItem] {
        var items = [BaseTableItem]()
        if let model = getModel() {
            let mirror = Mirror(reflecting: model)
            let children = mirror.getAllChildren()
            
            for i in children {
                let child = children[i]
                let item = BaseTableItem()
                item.name = child.0
                item.title = item.name.beautify()
                let value: String? = Convert(child.1).to()
                item.details = value
                items.append(buildItem(item: item))
            }
        }
        return items
    }
    
    func buildItem(item: BaseTableItem) -> BaseTableItem {
        if let editPage = self.delegate as? CustomEditPageDelegate {
            if let method = editPage.buildItem {
                return method(item)
            }
        }
        return item
    }
}

@objc
protocol CustomEditPageDelegate
{
    func buildModel() -> NSObject
    @objc optional func buildField(name: String, item: BaseTableItem, field: UIView) -> UIView
    @objc optional func buildItem(_ item: BaseTableItem) -> BaseTableItem
    @objc optional func buildHeader() -> UIView
    @objc optional func beforeDrawing(_ sender: CustomEditPage)
    @objc optional func afterDrawing(_ sender: CustomEditPage) -> Bool
}
