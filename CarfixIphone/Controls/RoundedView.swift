//
//  RoundedView.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 23/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class RoundedView: UIView {
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        initView()
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        initView()
//    }
    
    override func initView() -> RoundedView {
        _ = super.initView()
        
        self.roundIt()
        return self
    }
}
