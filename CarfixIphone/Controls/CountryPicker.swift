//
//  CountryPicker.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 28/12/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class CountryPicker: CustomPicker
{
    override func initView() -> CountryPicker {
        let items = NSMutableArray()
        items.add(Country.my.phoneCode)
        items.add(Country.ph.phoneCode)
        mItems = items
        
        return super.initView() as! CountryPicker
    }
    
    var mItems: NSArray!
    override func getPickOption() -> NSArray {
        return mItems
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        let result = getPickOption()[row]
        let rowString = result as! String
        
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 30, height: 30))
        if let country = Country.from(code: Convert(rowString).to()!) {
            let myImageView = UIImageView(frame: CGRect(x: 10, y: 5, width: 30, height: 20))
            if rowString != "" {
                myImageView.image = country.icon
            }
            let myLabel = UILabel(frame: CGRect(x: 60, y: 0, width: pickerView.bounds.width - 150, height: 30 ))
            myLabel.text = country.rawValue
            
            let myCode = UILabel(frame: CGRect(x: pickerView.bounds.width - 90, y: 0, width: 60, height: 30 ))
            myCode.textAlignment = .right
            myCode.text = "+\(country.code)"
            
            myView.addSubview(myCode)
            myView.addSubview(myLabel)
            myView.addSubview(myImageView)
        }
        
        return myView
    }
}
