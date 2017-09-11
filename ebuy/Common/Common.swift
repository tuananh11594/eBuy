//
//  Common.swift
//  ebuy
//
//  Created by Anh Tuan Nguyen on 6/9/17.
//  Copyright © 2017 Anh Tuan Nguyen. All rights reserved.
//

import Foundation
import UIKit

class Common {
    
    static func addAndFillSubviewIntoParentview(_ subview: UIView, parentview: UIView) {
        parentview.addSubview(subview)
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        parentview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subview]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["subview" : subview]))
        
        parentview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subview]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["subview" : subview]))
        
        parentview.layoutIfNeeded()
    }
}

