//
//  TapExtension.swift
//  Carfix2
//
//  Created by Re Foong Lim on 27/07/2016.
//  Copyright © 2016 Oneworks Sdn. Bhd. All rights reserved.
//

import Foundation

protocol Tap: AnyObject {}

extension Tap {
    func tap(block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}