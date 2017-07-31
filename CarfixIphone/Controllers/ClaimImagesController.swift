//
//  ClaimDocumentController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 28/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class ClaimImagesController: BaseFormController, HasImagePicker, UIGestureRecognizerDelegate, ViewImageControllerDelegate {
    
    @IBOutlet weak var btnUpload: CustomButton?
    
    var key: String?
    var singleFile: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
    }
    
    var mModel: GetClaimResult?
    func refresh() {
        CarFixAPIPost(self).getClaim(key: key!) { data in
            self.mModel = data?.Result
            
            if let model = self.mModel {
                self.mImagesExists = [:]
                if let items = model.PhotoCategories {
                    for item in items {
                        if let category = PhotoCategory(rawValue: item.Category) {
                            var list = [String]()
                            if let images = item.Images {
                                for image in images {
                                    if let path = image.Path {
                                        list.append(path)
                                    }
                                }
                            }
                            self.mImagesExists?.updateValue(list, forKey: category)
                        }
                    }
                }
            }
            
            self.redrawImages()
        }
    }
    
    func redrawImages() {
    }
    
    func drawImageUpload(category: PhotoCategory) {
        if let view = getImageContainer(category: category) {
            if let heightConstraint = getImageContainerHeight(category: category) {
                view.subviews.forEach({ $0.removeFromSuperview() })
                
                var x: CGFloat = 0
                var y: CGFloat = 0
                let width: CGFloat = view.bounds.width - x * 2
                
                let imageSize = Config.lineHeight * 4
                let iconSize = Config.iconSizeBig
                
                let btnAddBorder = BorderView(frame: CGRect(x: x, y: y, width: imageSize, height: imageSize)).initView()
                
                x = x + imageSize / 2 - iconSize / 2
                y = y + imageSize / 2 - iconSize / 2
                
                let btnAdd = CustomImageView(frame: CGRect(x: x, y: y, width: iconSize, height: iconSize)).initView()
                btnAdd.tintColor = CarfixColor.primary.color
                btnAdd.image = #imageLiteral(resourceName: "ic_add_circle")
                btnAddBorder.tag = Convert(category.rawValue).to()!
                btnAddBorder.addSubview(btnAdd)
                view.addSubview(btnAddBorder)
                
                let gestureAdd = UITapGestureRecognizer(target: self, action: #selector(pickImage(_:)))
                gestureAdd.delegate = self
                btnAddBorder.isUserInteractionEnabled = true
                btnAddBorder.addGestureRecognizer(gestureAdd)
                
                if singleFile == true {
                    if let images = mImages?[category] {
                        for image in images {
                            btnAdd.image = image
                            btnAdd.frame = btnAddBorder.bounds
                            break
                        }
                    }
                } else {
                    x = btnAddBorder.frame.width + Config.padding
                    y = 0
                    
                    if let images = mImagesExists?[category] {
                        var passImages = [String: UIImage?]()
                        for image in images {
                            passImages.updateValue(nil, forKey: image)
                        }
                        let point = drawImages(view: view, category: category, images: passImages, btnAddBorder: btnAddBorder, left: x, top: y, width: width, imageSize: imageSize)
                        x = point.x
                        y = point.y
                    }
                    
                    if let images = mImages?[category] {
                        var passImages = [String: UIImage?]()
                        var count = 0
                        for image in images {
                            passImages.updateValue(image, forKey: "\(count)")
                            count = count + 1
                        }
                        let point = drawImages(view: view, category: category, images: passImages, btnAddBorder: btnAddBorder, left: x, top: y, width: width, imageSize: imageSize)
                        x = point.x
                        y = point.y
                    }
                }
                
                heightConstraint.constant = view.estimateAdjustedRect().height
                
                btnUpload?.isEnabled = false
                if let images = mImages {
                    for image in images {
                        if image.value.count > 0 {
                            btnUpload?.isEnabled = true
                            break
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func uploadImages(_ sender: Any) {
        var imageList = [String: UIImage]()
        
        if let images = self.mImages {
            for item in images {
                var count = 0
                for image in item.value {
                    imageList["\(item.key.rawValue);\(count).jpg"] = resizeImage(sourceImage: image, scaledToWidth: Config.profileImageWidth)
                    count = count + 1
                }
            }
        }
        
        self.showProgressBar(msg: "The action might take few minutes to complete, please don’t close the apps until further instruction")
        
        if let key = key {
            CarFixAPIPost(self).uploadClaimPhotos(key: key, claimMessageId: nil, images: imageList) { data in
                self.mImages = [:]
                self.refresh()
            }
        }
    }
    
    func drawImages(view: UIView, category: PhotoCategory, images: [String: UIImage?], btnAddBorder: UIView, left: CGFloat, top: CGFloat, width: CGFloat, imageSize: CGFloat) -> CGPoint {
        var x = left
        var y = top
        
        for (path, image) in images {
            let imageView = CustomImageView(frame: CGRect(x: x, y: y, width: imageSize, height: imageSize)).initView()
            if let image = image {
                imageView.image = image
                imageView.tag = Convert(category.rawValue).to()!
            } else {
                ImageManager.downloadImage(mUrl: path, imageView: imageView)
                imageView.tag = Convert(category.rawValue).to()!
            }
            view.addSubview(imageView)
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(viewImage(sender:)))
            gesture.delegate = self
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(gesture)
            
            x = x + imageSize + Config.padding
            if x + imageSize > width {
                x = btnAddBorder.frame.origin.x + btnAddBorder.frame.width + Config.padding
                y = y + imageSize + Config.padding
            }
        }
        
        return CGPoint(x: x, y: y)
    }
    
    var viewImageCategory: PhotoCategory?
    func viewImage(sender: UIGestureRecognizer) {
        if let imageView = sender.view as? CustomImageView {
            if let category = PhotoCategory(rawValue: Convert(imageView.tag).to()!) {
                viewImageCategory = category
                performSegue(withIdentifier: Segue.segueViewImage.rawValue, sender: imageView)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let svc: ViewImageController = segue.getMainController()  {
            if let imageView = sender as? CustomImageView {
                if let category = viewImageCategory {
                    let images = getCategoryImages(category: category)
                    svc.images = images
                    var count = 0
                    for image in images {
                        if image == imageView.image {
                            break
                        }
                        count = count + 1
                    }
                    svc.index = count
                    if let count = mImagesExists?[category]?.count {
                        svc.indexCanRemove = count
                    }
                    svc.category = category
                    svc.delegate = self
                    svc.title = category.title
                }
            }
        }
    }
    
    func getImageContainer(category: PhotoCategory) -> UIView? {
        return nil
    }
    
    func getImageContainerHeight(category: PhotoCategory) -> NSLayoutConstraint? {
        return nil
    }
    
    func getCategoryImages(category: PhotoCategory) -> [UIImage] {
        var images = [UIImage]()
        
        if let view = getImageContainer(category: category) {
            var count = 0
            for subview in view.subviews {
                if count > 0 {
                    if let imageView = subview as? CustomImageView {
                        if let image = imageView.image {
                            images.append(image)
                        }
                    }
                }
                
                count = count + 1
            }
        }
        
        return images
    }
    
    func removeImage(category: PhotoCategory, index: Int) {
        mImages?[category]?.remove(at: index)
        drawImageUpload(category: category)
    }
    
    var photoCategory: PhotoCategory?
    func pickImage(_ sender: UIGestureRecognizer) {
        if let cat: Int16 = Convert(sender.view?.tag).to() {
            photoCategory = PhotoCategory(rawValue: cat)
        }
        self.cameraOrPhoto(sender: self, allowsEditing: false)
    }
    
    func imagePickerPreferredContentSize() -> CGSize {
        return CGSize(width: Config.profileImageWidth, height: Config.profileImageWidth)
    }
    
    var mImagesExists: [PhotoCategory: [String]]?
    var mImages: [PhotoCategory: [UIImage]]?
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if mImages.isEmpty {
            mImages = [:]
        }
        
        if let photoCategory = photoCategory {
            if mImages?[photoCategory] == nil {
                let images = [UIImage]()
                mImages?.updateValue(images, forKey: photoCategory)
            }
            
            if let image: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                if singleFile == true {
                    mImages?[photoCategory]?.removeAll()
                }
                mImages?[photoCategory]?.append(image)
            } else { print("some error message") }
            
            self.drawImageUpload(category: photoCategory)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}