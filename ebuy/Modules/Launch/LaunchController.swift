//
//  LaunchViewController.swift
//  ebuy
//
//  Created by Anh Tuan Nguyen on 6/9/17.
//  Copyright © 2017 Anh Tuan Nguyen. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit
import Google
import GoogleSignIn

class LaunchController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let email = UserDefaults.standard.object(forKey: Constants.NSUSerDefaultKey.Email) as? String {
            if let password = UserDefaults.standard.object(forKey: Constants.NSUSerDefaultKey.Password) as? String {
                AuthManager.sharedInstance.LoginEmail(email, pass: password , completion: { (isTrue, mesaage) in
                    if (isTrue) {
                        print("login compelete")
                        
                        AppDelegate.sharedDelegate().showHomeViewController()
                    } else {
                        print("login error")
                        
                        AppDelegate.sharedDelegate().showHomeViewController()
                    }
                })
                
            } else if let idToken = UserDefaults.standard.object(forKey: Constants.NSUSerDefaultKey.IdToken) as? String {
                AuthManager.sharedInstance.loginByGoogle(email, ggIDToken: idToken, completion: { (isTrue, mesaage) in
                    if (isTrue) {
                        print("login compelete")
                        
                        AppDelegate.sharedDelegate().showHomeViewController()
                    } else {
                        print("login error")
                        
                        AppDelegate.sharedDelegate().showHomeViewController()
                    }
                })
                
            } else {
                // Login Facebook Token
                AuthManager.sharedInstance.loginByFacebook(email, completion: { (isTrue, mesaage) in
                    if (isTrue) {
                        print("login compelete")
                        
                        AppDelegate.sharedDelegate().showHomeViewController()
                    } else {
                        print("login error")
                        
                        AppDelegate.sharedDelegate().showHomeViewController()
                    }
                })
            }
        }
        else {
            AppDelegate.sharedDelegate().showHomeViewController()
        }
        
    }
}
