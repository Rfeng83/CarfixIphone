//
//  DrawingPanel.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 22/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class DrawingPanel: BorderView {
    override func initView() -> DrawingPanel {
        _ = super.initView()
        
        DispatchQueue.main.async {
            self.viewBorder.lineWidth = 3
            
            let rect = CGRect(origin: self.bounds.origin, size: CGSize(width: round(self.bounds.width), height: round(self.bounds.height)))
            self.mainImageView = CustomImageView(frame: rect).initView()
            self.addSubview(self.mainImageView)
            self.tempImageView = CustomImageView(frame: rect).initView()
            self.addSubview(self.tempImageView)
            
            let clear = UIButton(frame: CGRect(origin: CGPoint(x: self.bounds.width - Config.iconSize - Config.padding, y: self.bounds.height - Config.iconSize - Config.padding), size: CGSize(width: Config.iconSize, height: Config.iconSize)))
            clear.systemImage = .trash
            self.addSubview(clear)
            
            clear.addTarget(self, action: #selector(self.reset), for: .touchUpInside)
        }
        return self
    }
    
    var placeholder: String? {
        get {
            return placeholderLabel?.text
        }
        set {
            if placeholderLabel.isEmpty {
                placeholderLabel = CustomLabel().initView()
            }
            placeholderLabel?.text = newValue
            DispatchQueue.main.async {
                if let placeholderLabel = self.placeholderLabel {
                    self.putCenter(control: placeholderLabel)
                }
            }
        }
    }
    
    private var placeholderLabel: CustomLabel?
    var tempImageView: CustomImageView!
    var mainImageView: CustomImageView!
    
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 2.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    var lastPoint = CGPoint.zero
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            if let view = self.tempImageView {
                lastPoint = touch.location(in: view)
            }
        }
        
        drawing(start: true)
    }
    
    func drawing(start: Bool) {
        if let scrollView: UIScrollView = self.getSuperView() {
            scrollView.isScrollEnabled = !start
            self.viewBorder.strokeColor = start ? CarfixColor.gray800.color.cgColor : CarfixColor.gray500.color.cgColor
        }
    }
    
    func drawLine(from: CGPoint, to: CGPoint) {
        if let view = tempImageView {
            // 1
            UIGraphicsBeginImageContext(view.frame.size)
            if let context = UIGraphicsGetCurrentContext() {
                let rect = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
                context.clear(rect)
                tempImageView.image?.draw(in: rect)
                
                // 2
                context.move(to: from)
                context.addLine(to: to)
                
                // 3
                context.setLineCap(.round)
                context.setLineWidth(brushWidth)
                context.setStrokeColor(CarfixColor.black.color.cgColor)
                context.setBlendMode(.normal)
                
                // 4
                context.strokePath()
                
                // 5
                tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
                tempImageView.alpha = opacity
                UIGraphicsEndImageContext()
                
                self.startDrawing()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            if let view = tempImageView {
                let currentPoint = touch.location(in: view)
                drawLine(from: lastPoint, to: currentPoint)
                
                lastPoint = currentPoint
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            // draw a single point
            drawLine(from: lastPoint, to: lastPoint)
        }
        
        if let view = self.tempImageView {
            // Merge tempImageView into mainImageView
            UIGraphicsBeginImageContext(view.frame.size)
            mainImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: .normal, alpha: 1.0)
            tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: .normal, alpha: opacity)
            mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        tempImageView.image = nil
        
        drawing(start: false)
    }
    
    func getImage() -> UIImage? {
        return mainImageView.image
    }
    
    func startDrawing() {
        placeholderLabel?.isHidden = true
    }
    func reset() {
        tempImageView.image = nil
        mainImageView.image = nil
        placeholderLabel?.isHidden = false
    }
}
