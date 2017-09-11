//
//  ProfileViewController.swift
//  ebuy
//
//  Created by Anh Tuan Nguyen on 6/3/17.
//  Copyright © 2017 Anh Tuan Nguyen. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit
import Google
import GoogleSignIn
import Firebase

class ProfileController: BaseController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var btnMessage: UIButton!
    
    @IBOutlet weak var btnFavorite: UIButton!
    
    @IBOutlet weak var viewBot: UIView!
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var btnLogout: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        circularImage(imgProfile)
        
        customButton(btnMessage)
        
        customButton(btnFavorite)
        
        addProfileTableView()
        
        self.addDisplayNameAndPhotoURL()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addProfileTableView()
    }
    
    @IBAction func btnBack(_ sender: AnyObject) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func btnLogout(_ sender: AnyObject) {
        do {
            try! FIRAuth.auth()!.signOut()
            
            let managerFB = FBSDKLoginManager()
            
            managerFB.logOut()
            
            GIDSignIn.sharedInstance().signOut()
            
            UserDefaults.standard.removeObject(forKey: Constants.NSUSerDefaultKey.Email)
            
            UserDefaults.standard.removeObject(forKey: Constants.NSUSerDefaultKey.Password)
            
            UserDefaults.standard.removeObject(forKey: Constants.NSUSerDefaultKey.IdToken)
            
            UserDefaults.standard.removeObject(forKey: Constants.NSUSerDefaultKey.uid)
            
            UserDefaults.standard.removeObject(forKey: Constants.NSUSerDefaultKey.name)
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            self.navigationController?.isNavigationBarHidden = false
            
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError)")
        }
    }
    
    func addDisplayNameAndPhotoURL(){
        if let user = FIRAuth.auth()?.currentUser {
            if let password = UserDefaults.standard.object(forKey: Constants.NSUSerDefaultKey.Password) as? String{
                let userID = FIRAuth.auth()?.currentUser?.uid
                //get photo back
                Constants.URL.baseURL.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    //                    self.lblName.text = snapshot.value!["name"] as? String
                    
                    // check if user has photo
                    if snapshot.hasChild("userPhoto"){
                        // set image locatin
                        let filePath = "\(userID!)/\("userPhoto")"
                        // Assuming a < 10MB file, though you can change that
                        Constants.URL.storageRef.child(filePath).data(withMaxSize: 10*1024*1024, completion: { (data, error) in
                            
                            let userPhoto = UIImage(data: data!)
                            
                            self.imgProfile.image = userPhoto
                        })
                    }
                })
                
            }else{
                self.lblName.text = user.displayName
                
                if let data = try? Data(contentsOf: user.photoURL!) {
                    imgProfile.image = UIImage(data:data)
                }
            }
        }
    }
    
    func addProfileTableView(){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileTableView"){
            vc.view.frame = self.view.bounds
            
            self.addChildViewController(vc)
            
            self.viewBot.addSubview(vc.view)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tapImgProfile()
    }
    
    func tapImgProfile(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImageView))
        
        tap.numberOfTapsRequired = 1
        
        self.imgProfile.isUserInteractionEnabled = true
        
        self.imgProfile.addGestureRecognizer(tap)
    }
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            imgProfile.image = selectedImage
            
            //save data
            dismiss(animated: true, completion: nil)
            
            var data = Data()
            
            data = UIImageJPEGRepresentation(selectedImage, 0.8)!
            
            // set upload path
            let filePath = "\(FIRAuth.auth()!.currentUser!.uid)/\("userPhoto")"
            
            let metaData = FIRStorageMetadata()
            
            metaData.contentType = "image/jpg"
            
            Constants.URL.storageRef.child(filePath).put(data, metadata: metaData){(metaData,error) in
                if let error = error {
                    print(error.localizedDescription)
                    
                    return
                }else{
                    //store downloadURL
                    let downloadURL = metaData!.downloadURL()!.absoluteString
                    
                    //store downloadURL at database
                    Constants.URL.baseURL.child("users").child(FIRAuth.auth()!.currentUser!.uid).updateChildValues(["userPhoto": downloadURL])
                }
                
            }
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

/*
 // MARK: - Custom Image, Button
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
extension ProfileController{
    
    func circularImage(_ photoImageView: UIImageView?)
    {
        photoImageView!.layer.frame = photoImageView!.layer.frame.insetBy(dx: 0, dy: 0)
        
        photoImageView!.layer.borderWidth = 4
        
        photoImageView!.layer.borderColor = UIColor.white.cgColor
        
        photoImageView!.layer.cornerRadius = photoImageView!.frame.height/2
        
        photoImageView!.layer.masksToBounds = false
        
        photoImageView!.clipsToBounds = true
        
        photoImageView!.contentMode = UIViewContentMode.scaleAspectFill
    }
    
    func customButton(_ button: UIButton?){
        button!.layer.cornerRadius = 17
        
        button!.layer.borderWidth  = 2
        
        button!.layer.borderColor = UIColor.white.cgColor
        
    }
    
}
