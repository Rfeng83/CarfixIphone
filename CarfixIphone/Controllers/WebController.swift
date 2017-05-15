//
//  WebController.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 23/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class WebController: UIViewController, UIWebViewDelegate {
    var url: URL!
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.backgroundColor = .white

        if let r = url {
            webView.loadRequest(URLRequest(url: r))
        }

        self.navigationController?.navigationBar.tintColor = CarfixColor.primary.color
        self.navigationController?.navigationBar.backgroundColor = CarfixColor.gray200.color
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: CarfixColor.primary.color]
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
}
