//
//  ViewImageController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 09/05/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class ViewImageController: BaseFormController, UIGestureRecognizerDelegate {
    var delegate: ViewImageControllerDelegate?
    
    @IBOutlet weak var imageView: CustomImageView!
    @IBOutlet weak var txtLabel: CustomLabel!
    @IBOutlet weak var btnLeft: CustomImageView!
    @IBOutlet weak var btnRight: CustomImageView!
    @IBOutlet weak var btnRemove: CustomButton!
    
    var images: [UIImage]!
    var index: Int!
    var category: PhotoCategory!
    var indexCanRemove: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureLeft = UITapGestureRecognizer(target: self, action: #selector(moveLeft))
        gestureLeft.delegate = self
        btnLeft.isUserInteractionEnabled = true
        btnLeft.addGestureRecognizer(gestureLeft)
        
        let gestureRight = UITapGestureRecognizer(target: self, action: #selector(moveRight))
        gestureRight.delegate = self
        btnRight.isUserInteractionEnabled = true
        btnRight.addGestureRecognizer(gestureRight)
        
        self.refresh()
    }
    
    func refresh() {
        imageView.image = images[index]
        let currentPage = index + 1
        txtLabel.text = "\(currentPage) / \(images.count)"
        btnRemove.isHidden = index < indexCanRemove
        
        btnLeft.isHidden = currentPage <= 1
        btnRight.isHidden = currentPage >= images.count
    }
    
    func moveLeft() {
        index = index - 1
        if index < 0 {
            index = 0
        }
        refresh()
    }
    
    func moveRight() {
        index = index + 1
        if index >= images.count {
            index = images.count - 1
        }
        refresh()
    }
    
    @IBAction func remove(_ sender: Any) {
        delegate?.removeImage(category: category, index: index - indexCanRemove)
        self.navigationController?.popViewController(animated: true)
    }
}

protocol ViewImageControllerDelegate {
    func removeImage(category: PhotoCategory, index: Int)
}
