//
//  RightBorder.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 20/12/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class RightBorder: UIView {
    override func draw(_ rect: CGRect) {
        let startingPoint = CGPoint(x: rect.maxX, y: rect.minY)
        let endingPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        
        let path = UIBezierPath()
        
        path.move(to: startingPoint)
        path.addLine(to: endingPoint)
        path.lineWidth = 2.0
        
        tintColor = CarfixColor.gray800.color
        tintColor.setStroke()
        
        path.stroke()
    }
}
