//
//  UIViewExtension.swift
//  Carfix2
//
//  Created by Re Foong Lim on 05/04/2016.
//  Copyright © 2016 Oneworks Sdn. Bhd. All rights reserved.
//

import Foundation
import UIKit

extension UIView
{
    open override func awakeFromNib() {
        _ = self.initView()
    }
    
    func initView() -> UIView {
        return self
    }
    
    func roundIt()
    {
        self.clipsToBounds = true;
        self.layer.cornerRadius = self.frame.size.width / 2;
    }
    
    func adjustSize() {
        adjustSize(extendRight: 0, extendBottom: 0)
    }
    
    func adjustSize(extendRight: CGFloat, extendBottom: CGFloat) {
        self.frame = estimateAdjustedRect(extendRight: extendRight, extendBottom: extendBottom)
    }
    
    func estimateAdjustedRect() -> CGRect {
        return estimateAdjustedRect(extendRight: 0, extendBottom: 0)
    }
    
    func estimateAdjustedRect(extendRight: CGFloat, extendBottom: CGFloat) -> CGRect {
        var rect = CGRect(x: 0, y: 0, width: 0, height: 0)
        for item in self.subviews {
            rect = rect.union(item.frame)
            rect = rect.union(item.estimateAdjustedRect())
        }
        if extendRight > 0 || extendBottom > 0 {
            rect.size = CGSize(width: rect.size.width + extendRight, height: rect.size.height + extendBottom)
        }
        return CGRect(origin: self.frame.origin, size: rect.size)
    }
    
    func drawLeftShadow(){
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: -2, height: 1)
    }
    func drawRightShadow(){
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 2, height: 1)
    }
    
    func addBackground(image: UIImage) {
        // screen width and height:
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x:0, y:0, width:width, height:height))
        imageViewBackground.image = image
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubview(toBack: imageViewBackground)
    }
    //
    //    func addBackground(image: UIImage, scaleByWidth: Bool) {
    //        // screen width and height:
    //        let width = self.bounds.size.width
    //        var height: CGFloat
    //        if scaleByWidth {
    //            height = image.size.height * width / image.size.width
    //        } else {
    //            height = image.size.height
    //        }
    //
    //        let imageViewBackground = UIImageView(frame: CGRect(x:0, y:0, width:width, height:height))
    //        imageViewBackground.image = image
    //
    //        // you can change the content mode:
    //        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
    //
    //        self.addSubview(imageViewBackground)
    //        self.sendSubview(toBack: imageViewBackground)
    //    }
    
    func getView<T>() -> T? {
        let items: [T] = getAllViews()
        if items.count > 0 {
            return items[0]
        } else {
            return nil
        }
    }
    func getAllViews<T>() -> [T] {
        var items = [T]()
        for item in self.subviews {
            if let item = item as? T {
                items.append(item)
            } else {
                let children: [T] = item.getAllViews()
                for child in children {
                    items.append(child)
                }
            }
        }
        
        return items
    }
    func getSuperView<T>() -> T? {
        if let item = self.superview as? T {
            return item
        } else {
            return self.superview?.getSuperView()
        }
    }
    
    func startGlowing() {
        self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: [.allowUserInteraction, .repeat],
                       animations: { [weak self] in
                        self?.transform = .identity
                        self?.drawLeftShadow()
                        self?.drawRightShadow()
                        
            },
                       completion: nil)
    }
    
    func startPulsing() {
        DispatchQueue.main.async(execute: {
            let pulsing = Pulsing(numberOfPulses: Float.infinity, radius: 16, position: self.center)
            pulsing.animationDuration = 1
            pulsing.backgroundColor = CarfixColor.yellow.color.cgColor
            self.superview?.layer.insertSublayer(pulsing, below: self.layer)
        })
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(250), execute: {
            let pulsing = Pulsing(numberOfPulses: Float.infinity, radius: 16, position: self.center)
            pulsing.animationDuration = 1
            pulsing.backgroundColor = CarfixColor.yellow.color.cgColor
            self.superview?.layer.insertSublayer(pulsing, below: self.layer)
        })
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func pushHeight(height: CGFloat) {
        if height != 0 {
            self.frame = CGRect(origin: CGPoint(x: self.frame.origin.x, y: self.frame.minY + height), size: self.frame.size)
        }
    }
    
    func putCenter(control: UIView) {
        if !self.subviews.contains(control) {
            self.addSubview(control)
        }
        
        if let control = control as? CustomLabel {
            let width = control.fitWidth()
            if width > self.bounds.width {
                control.frame.size = CGSize(width: self.bounds.width, height: Config.lineHeight)
            }
            _ = control.fitHeight()
        }
        
        control.frame = CGRect(origin: CGPoint(x: (self.bounds.width - control.bounds.width) / 2, y: (self.bounds.height - control.bounds.height) / 2), size: control.bounds.size)
    }
}
