//
//  ForgotPasswordController.swift
//  ebuy
//
//  Created by Anh Tuan Nguyen on 5/15/17.
//  Copyright © 2017 Anh Tuan Nguyen. All rights reserved.
//

import Foundation
import UIKit
class ForgotPasswordController: BaseController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSendPassword: UIButton!
    
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
    @IBAction func btnSendPassword(_ sender: UIButton) {
        let authManager: AuthManager = AuthManager()
        if let email = txtEmail.text {
            //LoadingOverlay.shared.showOverlay(self.view)
            self.view.isUserInteractionEnabled = false
            
            authManager.forgotPassword(email){ (isForgotPassword,message) in
                if isForgotPassword {
                    //self.view.userInteractionEnabled = true
                    
                    //LoadingOverlay.shared.hideOverlayView()
                    
                    self.showAlert("\(message)")
                }else{
                    //self.view.userInteractionEnabled = true
                    //LoadingOverlay.shared.hideOverlayView()
                    self.showAlert("\(message)")
                }
            }

        }
        
    }
    
    
    func userInterface(){
        // Set backgroud
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "RegisterBackgound")
        self.view.insertSubview(backgroundImage, at: 0)
        
        //change layer button
        btnCancel.layer.cornerRadius = 5
        btnSendPassword.layer.cornerRadius = 5
    }
}
