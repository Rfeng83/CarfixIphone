//
//  CustomNumericField.swift
//  Carfix2
//
//  Created by Re Foong Lim on 13/04/2016.
//  Copyright © 2016 Oneworks Sdn. Bhd. All rights reserved.
//

import Foundation
import UIKit

class CustomDecimalField: CustomTextField
{
    override func initView() -> CustomDecimalField {
        _ = super.initView()
        self.keyboardType = .decimalPad
        return self
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
}
