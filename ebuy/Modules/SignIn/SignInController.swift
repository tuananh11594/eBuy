//
//  SignInViewController.swift
//  ebuy
//
//  Created by Anh Tuan Nguyen on 5/14/17.
//  Copyright © 2017 Anh Tuan Nguyen. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit
import Google
import GoogleSignIn

class SignInController: BaseController, GIDSignInDelegate, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnLoginWithFacebook: UIButton!
    @IBOutlet weak var btnLoginWithGoogle: UIButton!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        userInterface()
        
    }
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnRegister(_ sender: UIButton) {
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        if let email = txtEmail.text , let pass = txtPassword.text {
            LoadingOverlay.shared.showOverlay(self.view)
            self.view.isUserInteractionEnabled = false
            AuthManager.sharedInstance.LoginEmail(email, pass: pass, completion: { (isLogin, message) in
                self.view.isUserInteractionEnabled = true
                if isLogin {
                    LoadingOverlay.shared.hideOverlayView()
                    print("Login email success")
                    self.homeNavigation()
                    return
                }
                LoadingOverlay.shared.hideOverlayView()
                self.showAlert("Invalid email or password!")
                
            })
        }
    }
    
    @IBAction func btnLoginFacebook(_ sender: UIButton) {
        let facebookReadPermissions = ["public_profile", "email", "user_friends"]
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        fbLoginManager.loginBehavior = FBSDKLoginBehavior.browser
        
        fbLoginManager.logIn(withReadPermissions: facebookReadPermissions, handler: { (result, error) -> Void in
            if error == nil{
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                    self.showEmailAddress()
                
                if fbloginresult.isCancelled{
                    print("Login cancel")
                }else{
                    self.fetchUserInfo()
                }
            }else{
                print("error")
            }
        })
 
    }
    
    @IBAction func btnLoginGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    //FacebookButtonDelegate
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!){
        if error != nil {
            print(error)
            return
        }
        print("Login Facebook succes")
        self.showEmailAddress()
    }
    //GIDSignInDelegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            
            return
        }
        let ggAccessToken = user.authentication.accessToken
        
        let idToken = user.authentication.idToken
        
        let authentication = user.authentication
        
        let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!,accessToken: (authentication?.accessToken)!)
        
        AuthManager.sharedInstance.loginByGoogle(ggAccessToken!, ggIDToken: idToken!, completion: { (isLogin,message) in
            
            if isLogin {
                
                print("sign google complete")
                
                LoadingOverlay.shared.hideOverlayView()
                
                self.view.isUserInteractionEnabled = true
                
                self.homeNavigation()
                
            }else{
                LoadingOverlay.shared.hideOverlayView()
                
                self.view.isUserInteractionEnabled = true
                
                self.showAlert("Error: \(message)")
                
            }
        })
    }
    
    func fetchUserInfo(){
        if((FBSDKAccessToken.current()) != nil){
            let accessTokenFB = FBSDKAccessToken.current().tokenString
            
            // Login Facebook Token
            AuthManager.sharedInstance.loginByFacebook(accessTokenFB!, completion: { (isLogin,message) in
                
                if isLogin {
                    
                    print("sign google complete")
                    
                    LoadingOverlay.shared.hideOverlayView()
                    
                    self.view.isUserInteractionEnabled = true
                    
                    self.homeNavigation()
                    
                }else{
                    LoadingOverlay.shared.hideOverlayView()
                    
                    self.view.isUserInteractionEnabled = true
                    
                    self.showAlert("Error: \(message)")
                    
                }
            })
            
        }
    }
    
    func showEmailAddress(){
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {
            return
        }
        let creddentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        FIRAuth.auth()?.signIn(with: creddentials, completion: { (user, error) in
            if error != nil{
                print("Something went wrong with our FB user", error ?? "")
                return
            }
            
            print("Successfully logged in with our user: ", user ?? "")
        })
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id,name,email"]).start(completionHandler: {(connection, result,err) -> Void in
            if err != nil {
                print("Failed to start graph request", err ?? "")
                return
            }
            
            print(result ?? "")
        })
    }
    
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!){
        print("Facebook logout")
    }
    
}

extension SignInController {
    
    func userInterface(){
        // Delegate Google
        var configureError: NSError?
        
        GGLContext.sharedInstance().configureWithError(&configureError)
        
        if configureError != nil {
            print(configureError)
        }
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        GIDSignIn.sharedInstance().delegate = self
        // Delegate Facebook
        //Set backgrount image for view
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "SignInBackgound")
        self.view.insertSubview(backgroundImage, at: 0)
        
        //change layer of buttons
        btnLogin.layer.cornerRadius = 5
        btnRegister.layer.cornerRadius = 5
        
        txtEmail.textColor = UIColor.white
        txtPassword.textColor = UIColor.white
        
        // Config hiden Keyboard click in view
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //navigationBar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    // Action for tap gesture
    override func dismissKeyboard() {
        view.endEditing(true)
        
    }
    
    func homeNavigation(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.isNavigationBarHidden = false
    }
}
