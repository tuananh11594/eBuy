 //
//  RegisterViewController.swift
//  ebuy
//
//  Created by Anh Tuan Nguyen on 5/9/17.
//  Copyright © 2017 Anh Tuan Nguyen. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class RegisterController: BaseController {
    

    @IBOutlet weak var txtCheckPassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFullname: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    let user = FIRAuth.auth()?.currentUser

    override func viewDidLoad(){
        super.viewDidLoad()
        
        userInterface()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        if let email = txtEmail.text , let password = txtPassword.text, let checkPass = txtCheckPassword.text, let fullName = txtFullname.text {
            LoadingOverlay.shared.showOverlay(self.view)
            
            self.view.isUserInteractionEnabled = false
            
            let register: AuthManager = AuthManager()
            
            register.Register(fullName, email: email, passWord: password, passWordAgain: checkPass){ (isRegister,message) in
                if isRegister{
                    LoadingOverlay.shared.hideOverlayView()
                    if let userID = self.user?.uid {
                        let Topic = UserModel(fullName: fullName, email: email, avatar: "Not update")
                        let topicsRef = Constants.URL.baseURL.child("users").child(userID)

                        topicsRef.setValue(Topic.toDictionary())

                    } else {
                        self.showAlert("You need sign in again!")
                    }
                    self.view.isUserInteractionEnabled = true
                    
                    self.showAlert()
                    
                }else{
                    LoadingOverlay.shared.hideOverlayView()
                    
                    self.view.isUserInteractionEnabled = true
                    
                    self.showAlert(message)
                }
                
            }

        }
    }
}
 
 extension RegisterController {
    func userInterface() {
        //Set backgrount image for view
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "RegisterBackgound")
        self.view.insertSubview(backgroundImage, at: 0)
        
        //Change layer button
        //        btnCheck.layer.cornerRadius = 5
        btnCancel.layer.cornerRadius = 5
        btnSubmit.layer.cornerRadius = 5
        
    }
    
    // Alert move Login
    func showAlert(){
        let alert = UIAlertController(title: nil, message: "Register complete.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",style: .default, handler: { action in
            self.homeNavigation1()
            
        }))
        alert.addAction(UIAlertAction(title: "CANCEL",style: .cancel, handler:nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func homeNavigation1(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
        self.navigationController?.pushViewController(vc, animated: true)
        
        self.navigationController?.isNavigationBarHidden = false
    }
 }
