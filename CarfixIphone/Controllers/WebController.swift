//
//  WebController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 23/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class WebController: BaseController, UIWebViewDelegate {
    var delegate: BaseFormReturnData?
    var url: URL!
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var btnNextHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.backgroundColor = .white

        if let r = url {
            webView.loadRequest(URLRequest(url: r))
        }

        self.navigationController?.navigationBar.tintColor = CarfixColor.primary.color
        self.navigationController?.navigationBar.backgroundColor = CarfixColor.gray200.color
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: CarfixColor.primary.color]
        
        if self.delegate.hasValue {
            btnNextHeight.constant = 49
        } else {
            btnNextHeight.constant = 0
        }
    }
    
    var boxView: UIView!
    func webViewDidStartLoad(_ webView: UIWebView) {
        showProgressBar()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        hideProgressBar()
        
        let contentSize:CGSize = webView.scrollView.contentSize
        let viewSize:CGSize = self.view.bounds.size
        
        let rw:CGFloat = viewSize.width / contentSize.width
        
        webView.scrollView.minimumZoomScale = rw
        webView.scrollView.maximumZoomScale = rw
        webView.scrollView.zoomScale = rw
    }
    
    override func getBackgroundImage() -> UIImage? {
        return nil
    }
    
    @IBAction func next(_ sender: Any) {
        self.delegate?.returnData(sender: self, item: true)
    }
}
