//
//  Constants.swift
//  ebuy
//
//  Created by Anh Tuan Nguyen on 6/9/17.
//  Copyright © 2017 Anh Tuan Nguyen. All rights reserved.
//

import Foundation
import Firebase

class Constants {
    struct ViewControllers {
        static let RootViewController = "RootViewController"
        
    }
    
    struct Models {
        static let MUser = "MUser"
    }
    
    struct CustomViews {
        
    }
    
    struct NSUSerDefaultKey {
        static let Email = "kNSUserDefaultKeyEmail"
        
        static let Password = "kNSUserDefaultKeyPassword"
        
        static let IdToken = "kNSUserDefaultKeyIdToken"
        
        static let uid = "kNSUserDefaultKeyUid"
        
        static let name = "kNSUSerDefaultName"
    }
    
    struct URL{
        static var baseURL =  FIRDatabase.database().reference(fromURL: "https://ebuy-c1b04.firebaseio.com/")
        
        static var storageRef = FIRStorage.storage().reference(forURL: "gs://ebuy-c1b04.appspot.com")

    }
    
    struct  Register {
        static var fullName = "name"
        
        static var email = "email"
        
        static var permission = "permission"
        
        static var permissionValues = "false"
        
        static var image = "image"
        
        
    }
    
    
    
}
