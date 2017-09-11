//
//  LoadingOverlay.swift
//  ebuy
//
//  Created by Anh Tuan Nguyen on 6/9/17.
//  Copyright © 2017 Anh Tuan Nguyen. All rights reserved.
//

import UIKit
open class LoadingOverlay{
    var overlayView : UIView!
    
    var activityIndicator : UIActivityIndicatorView!
    
    class var shared: LoadingOverlay {
        struct Static {
            
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        
        return Static.instance
    }
    
    init(){
        self.overlayView = UIView()
        
        self.activityIndicator = UIActivityIndicatorView()
        
        overlayView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        
        overlayView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        overlayView.clipsToBounds = true
        
        overlayView.layer.cornerRadius = 10
        
        overlayView.layer.zPosition = 1
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        
        overlayView.addSubview(activityIndicator)
    }
    
    open func showOverlay(_ view: UIView) {
        overlayView.center = view.center
        
        view.addSubview(overlayView)
        
        activityIndicator.startAnimating()
    }
    
    open func hideOverlayView() {
        
        activityIndicator.stopAnimating()
        
        overlayView.removeFromSuperview()
    }
}
