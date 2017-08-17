//
//  ClaimDocumentController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 28/07/2017.
//  Copyright © 2017 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class ClaimAccidentImagesController: ClaimImagesController {
    @IBOutlet weak var viewImages: UIView!
    @IBOutlet weak var viewImagesHeight: NSLayoutConstraint!
    
    @IBOutlet weak var imgAngle1: CustomImageView!
    @IBOutlet weak var imgAngle2: CustomImageView!
    @IBOutlet weak var imgAngle3: CustomImageView!
    @IBOutlet weak var imgAngle4: CustomImageView!
    
    class ImageInfo {
        var url: String!
        var thumb: String!
        var title: String!
        
        required init(url: String, thumb: String, title: String) {
            self.url = url
            self.thumb = thumb
            self.title = title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewAngle(img: imgAngle1, info: ImageInfo(url: "http://www.carfix.my/Data/User/Image/Setting/Windscreen_1.png", thumb: "http://www.carfix.my/Data/User/Image/Setting/Windscreen_1_thumb.png", title: "Front"))
        viewAngle(img: imgAngle2, info: ImageInfo(url: "http://www.carfix.my/Data/User/Image/Setting/Windscreen_2.png", thumb: "http://www.carfix.my/Data/User/Image/Setting/Windscreen_2_thumb.png", title: "Back"))
        viewAngle(img: imgAngle3, info: ImageInfo(url: "http://www.carfix.my/Data/User/Image/Setting/Windscreen_3.png", thumb: "http://www.carfix.my/Data/User/Image/Setting/Windscreen_3_thumb.png", title: "Road Tax"))
        viewAngle(img: imgAngle4, info: ImageInfo(url: "http://www.carfix.my/Data/User/Image/Setting/Windscreen_4.png", thumb: "http://www.carfix.my/Data/User/Image/Setting/Windscreen_4_thumb.png", title: "Chassis Number"))
    }
    
    func viewAngle(img: CustomImageView, info: ImageInfo) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewAngleImage(_:)))
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(gesture)
        img.data = info
        ImageManager.downloadImage(mUrl: info.thumb, imageView: img)
    }
    
    func viewAngleImage(_ sender: UIGestureRecognizer) {
        if let image = sender.view as? CustomImageView {
            performSegue(withIdentifier: Segue.segueWeb.rawValue, sender: image.data)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let svc: WebController = segue.getMainController() {
            if let info = sender as? ImageInfo {
                svc.url = URL(string: info.url)
                svc.title = info.title
            }
        }
    }
    
    override func redrawImages() {
        self.drawImageUpload(category: .AccidentImages)
    }
    
    override func getImageContainer(category: PhotoCategory) -> UIView? {
        return viewImages
    }
    
    override func getImageContainerHeight(category: PhotoCategory) -> NSLayoutConstraint? {
        return viewImagesHeight
    }
    
    override func existsImageRemovable() -> Bool {
        return true
    }
}
