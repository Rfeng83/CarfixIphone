//
//  NavigationBackButton.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 23/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class NavigationBackButton: UIBarButtonItem {
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        initView()
//    }

    override func awakeFromNib() {
        initView()
    }
    
    func initView() {
        self.tintColor = CarfixColor.primary.color
    }
}
