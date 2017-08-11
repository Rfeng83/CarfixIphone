//
//  CustomImage.swift
//  Carfix2
//
//  Created by Re Foong Lim on 27/09/2016.
//  Copyright © 2016 Oneworks Sdn. Bhd. All rights reserved.
//

import Foundation
import UIKit

class CustomImageView: UIImageView {
    var key: String?
    var path: String?
    
    override func initView() -> CustomImageView {
        _ = super.initView()
        return self
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.clear(self.bounds)
    }
}
