//
//  CustomTableViewCell.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 20/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class CustomTableViewCell: UITableViewCell {
    var titleLabel: CustomLabel!
    var detailsLabel: CustomLabel!
    var leftImage: CustomImageView!
    
    override func initView() -> CustomTableViewCell {
        _ = super.initView()
        
        self.backgroundColor = .clear

        let screenSize: CGRect = UIScreen.main.bounds
        
        let margin: CGFloat = Config.margin
        let padding: CGFloat = Config.padding
        
        var x: CGFloat = margin + padding
        var y: CGFloat = padding
        let height: CGFloat = Config.lineHeight
        
        let imageWidth: CGFloat = Config.lineHeight * 2
        
        self.leftImage = CustomImageView(frame: CGRect(x: x, y: y, width: imageWidth, height: imageWidth)).initView()
        self.addSubview(self.leftImage)
        
        x = x + imageWidth + padding
        let width: CGFloat = screenSize.width - x - (margin + padding) * 2
        
        self.titleLabel = CustomLabel(frame: CGRect(x: x, y: y, width: width, height: height)).initView()
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: Config.fontSize)
        self.addSubview(self.titleLabel)
        
        y = y + height
        
        self.detailsLabel = CustomLabel(frame: CGRect(x: x, y: y, width: width, height: height)).initView()
        self.addSubview(self.detailsLabel)
        
        return self
    }
    
    func initCell(item: BaseTableItem) {
        self.titleLabel.text = item.title
        self.detailsLabel.text = item.details
        if let image = item.leftImage {
            self.leftImage.image = image
        }
        if let path = item.leftImagePath {
            ImageManager.downloadImage(mUrl: path, imageView: self.leftImage)
        }
    }
}
