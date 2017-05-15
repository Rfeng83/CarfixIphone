//
//  CustomIntegerField.swift
//  Carfix2
//
//  Created by Re Foong Lim on 13/04/2016.
//  Copyright © 2016 Oneworks Sdn. Bhd. All rights reserved.
//

import Foundation
import UIKit

class CustomIntegerField: CustomDecimalField
{
    override func initView() -> CustomIntegerField {
        _ = super.initView()
        self.keyboardType = .numberPad
        return self
    }
}
