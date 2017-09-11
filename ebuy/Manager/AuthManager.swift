//
//  AuthManager.swift
//  ebuy
//
//  Created by Anh Tuan Nguyen on 6/9/17.
//  Copyright © 2017 Anh Tuan Nguyen. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

public typealias Login = (_ isTrue: Bool, _ mesaage: String) -> Void

class AuthManager {
    static let sharedInstance = AuthManager()
    
    func loginByFacebook(_ fbAccessToken: String, completion: @escaping Login) {
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: fbAccessToken)
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                
                completion(false,(error?.localizedDescription)!)
            }else{
                
                completion(true,"Login Complete")
                
                UserDefaults.standard.set(fbAccessToken, forKey: Constants.NSUSerDefaultKey.Email)
                
                UserDefaults.standard.synchronize()
            }
        })
        
    }
    
    func loginByGoogle(_ ggAccessToken: String, ggIDToken: String, completion: @escaping Login) {
        
        let credential = FIRGoogleAuthProvider.credential(withIDToken: ggIDToken,accessToken: ggAccessToken)
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            if error != nil {
                
                completion(false,(error?.localizedDescription)!)
            }else{
                completion(true,"Login Complete")
                
                UserDefaults.standard.set(ggAccessToken, forKey: Constants.NSUSerDefaultKey.Email)
                
                UserDefaults.standard.set(ggIDToken, forKey: Constants.NSUSerDefaultKey.IdToken)
                
                UserDefaults.standard.synchronize()
            }
        }
        
    }
    
    func LoginEmail(_ email: String,pass: String,completion: @escaping Login){
        if validateEmail(email){
            if validatePass(pass){
                FIRAuth.auth()?.signIn(withEmail: email, password: pass) { (user, error) in
                    if error != nil {
                        completion(false,(error?.localizedDescription)!)
                    }else{
                        completion(true,"Login Complete")
                        
                        UserDefaults.standard.set(email, forKey: Constants.NSUSerDefaultKey.Email )
                        
                        UserDefaults.standard.set(pass, forKey: Constants.NSUSerDefaultKey.Password)
                        
                        UserDefaults.standard.synchronize()
                    }
                }
            }else{
                completion(false,"Password <= 7 error")
            }
        }else{
            completion(false,"Check email again ")
        }
        
    }
    func Register(_ fullName: String, email: String, passWord: String, passWordAgain: String,completion: @escaping Login){
        
        if validateFullName(fullName){
            
            if validateEmail(email){
                
                if validatePass(passWord) || validatePass(passWordAgain){
                    
                    if validateTowPass(passWord, pass2: passWordAgain){
                        
                        FIRAuth.auth()?.createUser(withEmail: email, password: passWord, completion: { (user, error) in
                            
                            guard let uid = user?.uid else {
                                return
                            }
                            
                            if error != nil {
                                completion(false, (error?.localizedDescription)!)
                                
                            }else{
                                completion(true, "Register Complete")
                                
                                let users = [
                                    Constants.Register.fullName : fullName,
                                    
                                    Constants.Register.email : email,
                                    
                                    Constants.Register.permission: Constants.Register.permissionValues,
                                    ]
                                APIMananger.sharedInstance.registerUserIntoDatabaseWithUID(uid, user: users)
                                
                                //login
                                AuthManager.sharedInstance.LoginEmail(email, pass: passWord, completion: { (isTrue, mesaage) in
                                    if (isTrue) {
                                        
                                        print("login compelete")
                                        
                                    } else {
                                        
                                        print("login error")
                                        
                                    }
                                })
                                
                                //set uid
                                UserDefaults.standard.set(uid, forKey: Constants.NSUSerDefaultKey.uid)
                                
                                UserDefaults.standard.set(fullName, forKey: Constants.NSUSerDefaultKey.name)
                                
                                UserDefaults.standard.synchronize()
                                
                            }
                        })
                    }else{
                        completion(false, "Password doesn't not mach")
                    }
                }else{
                    completion(false, "Please check password")
                }
            }else{
                completion(false, "Please check email")
            }
        }else{
            completion(false, "Please check full name")
        }
    }
    
    // ForgotPassword
    func forgotPassword(_ email: String, completion: @escaping Login){
        if validateEmail(email){
            FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
                if error == nil {
                    completion(true, "An email with information on how to reset your password has been sent to you. thank You" )
                }else {
                    completion(false, (error?.localizedDescription)!)
                }
            })
        }else{
            completion(false, "Please check your email!")
        }
    }
}

extension AuthManager{
    func validateEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let matches = email.range(of: regex, options: .regularExpression)
        
        if let _ = matches {
            return true
        }
        return false
    }
    
    func validatePass(_ pass:String) -> Bool{
        if(pass.characters.count <= 7){
            return false
        }
        return true
    }
    
    func validateFullName(_ name:String) -> Bool{
        if name.characters.count <= 0{
            return false
        }
        return true
    }
    
    func validateTowPass(_ pass1:String,pass2:String) -> Bool{
        if pass1 == pass2 {
            return true
        }
        return false
    }
}
