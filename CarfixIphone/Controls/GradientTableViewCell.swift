//
//  CustomTableViewCell.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 20/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class GradientTableViewCell: CustomTableViewCell {
    var grayBackground: UIView!
    
    override func initView() -> GradientTableViewCell {
        self.backgroundColor = .clear
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        self.selectedBackgroundView = selectedBackgroundView
        
        let screenSize: CGRect = UIScreen.main.bounds
        let frame = self.frame
        
        let margin: CGFloat = Config.margin
        
        grayBackground = UIView(frame: CGRect(origin: CGPoint(x: margin, y: margin / 2), size: CGSize(width: screenSize.width - margin * 2, height: frame.height - margin)))
        grayBackground.backgroundColor = UIColor(white: 0, alpha: 0.25)
        self.addSubview(grayBackground)
        
        _ = super.initView()
        
        let padding: CGFloat = Config.padding
        
        var x: CGFloat = margin + padding
        var y: CGFloat = padding
        let height: CGFloat = Config.lineHeight
        
        let imageWidth: CGFloat = Config.lineHeight * 2
        
        self.leftImage.frame = CGRect(x: x, y: y, width: imageWidth, height: imageWidth)
        
        x = x + imageWidth + padding
        let width: CGFloat = screenSize.width - x - (margin + padding) * 2
        
        self.titleLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        self.titleLabel.textColor = .white
        
        y = y + height
        
        self.detailsLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        self.detailsLabel.textColor = .white
        
        return self
    }
    
    override func initCell(item: BaseTableItem) {
        super.initCell(item: item)
        self.grayBackground.frame = CGRect(origin: self.grayBackground.frame.origin, size: CGSize(width: self.grayBackground.frame.size.width, height: self.frame.size.height - Config.margin))
    }
}
