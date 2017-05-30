//
//  HasImagePicker.swift
//  Carfix2
//
//  Created by Re Foong Lim on 20/09/2016.
//  Copyright © 2016 Oneworks Sdn. Bhd. All rights reserved.
//

import Foundation
import UIKit

protocol HasImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
}

extension HasImagePicker where Self: UIViewController {
    func cameraOrPhoto(sender: AnyObject) {
        cameraOrPhoto(sender: sender, allowsEditing: true)
    }
    func cameraOrPhoto(sender: AnyObject, allowsEditing: Bool) {
        let refreshAlert = UIAlertController(title: "", message: "Please select Camera or Photo", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction!) in
            self.camera(allowsEditing: allowsEditing)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Photo", style: .default, handler: { (action: UIAlertAction!) in
            self.photo(allowsEditing: allowsEditing)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(refreshAlert, animated: true, completion: {
            refreshAlert.view.superview?.isUserInteractionEnabled = true
            //            refreshAlert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissPopupView)))
        })
    }
    func imagePickerPreferredContentSize() -> CGSize {
        let size = self.view.frame.size.width
        return CGSize(width: size, height: size)
    }
    func camera() {
        camera(allowsEditing: true)
    }
    func camera(allowsEditing: Bool) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = allowsEditing
        imagePicker.showsCameraControls = true
        imagePicker.setEditing(true, animated: true)
        imagePicker.preferredContentSize = imagePickerPreferredContentSize()
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    func photo() {
        photo(allowsEditing: true)
    }
    func photo(allowsEditing: Bool) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = allowsEditing
        imagePicker.setEditing(true, animated: true)
        imagePicker.preferredContentSize = imagePickerPreferredContentSize()
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func resizeImage (sourceImage: UIImage, scaledToWidth: CGFloat) -> UIImage {
        let oldWidth = sourceImage.size.width
        let scaleFactor = scaledToWidth / oldWidth
        
        let newHeight = sourceImage.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    //    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    //
    //        var myImageName: String
    //
    //        let uuid = NSUUID()
    //        myImageName = uuid.uuidString + ".JPEG"
    //
    //        if let imagePath = ImageManager.fileInDocumentsDirectory(filename: myImageName) {
    //            if let image: UIImage = info[UIImagePickerControllerEditedImage] as? UIImage {
    //                //                let squareImage = ImageManager.RBSquareImageTo(image, size: CGSize.init(width: 500, height: 500))
    //                if !ImageManager.saveImage(image: image, path: imagePath) {
    //                    print("failed to save image")
    //                }
    //            } else { print("some error message") }
    //        }
    //
    //        self.loadImage(with: myImageName)
    //        self.dismiss(animated: true, completion: nil)
    //    }
    
}
