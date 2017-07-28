//
//  DarkIcon.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 22/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation

class DarkIcon: CustomImageView {
    override func initView() -> DarkIcon {
        self.tintColor = CarfixColor.gray700.color
        return self
    }
}
