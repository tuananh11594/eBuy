//
//  PostAddController.swift
//  ebuy
//
//  Created by Nguyen Tuan Anh on 6/13/17.
//  Copyright © 2017 Anh Tuan Nguyen. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class PostAddController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate,CategoryControllerDelegate  {
    
    @IBOutlet weak var btnImage1: UIButton!
    @IBOutlet weak var btnImage2: UIButton!
    @IBOutlet weak var btnImage3: UIButton!
    @IBOutlet weak var btnImage4: UIButton!
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var btnPostAdd: UIButton!
    
    
    let ref = FIRDatabase.database().reference(fromURL: "https://ebuy-c1b04.firebaseio.com/")
    let user = FIRAuth.auth()?.currentUser
    
    //arrayImages save image from device
    var arrayImages : [UIImage] = []
    
    //arrayLinkImages save url dowload off images from firebase
    var arrayLinkImages : [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userInterface()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

    }
    
    @IBAction func btnCategory(_ sender: UIButton) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let yourVC = mainStoryboard.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
        yourVC.delegate = self
        yourVC.selectedCat = btnCategory.titleLabel?.text
        self.navigationController?.pushViewController(yourVC, animated: true)
    }

    @IBAction func btnImage1(_ sender: UIButton) {
        camera()
    }
    
    @IBAction func btnImage2(_ sender: UIButton) {
        camera()
    }
    @IBAction func btnImage3(_ sender: UIButton) {
        camera()
    }
    @IBAction func btnImage4(_ sender: UIButton) {
        camera()
    }
    

    @IBAction func btnPostAdd(_ sender: Any) {
        if let title = self.txtTitle.text{
            if let phone = self.txtPhone.text{
                if let price = Int(self.txtPrice.text!){
                    if let address = self.txtAddress.text{
                        if let description = self.txtDescription.text{
                            if let category = self.btnCategory.currentTitle {
                                if self.arrayImages.count > 0 {
                                    LoadingOverlay.shared.showOverlay(self.view)
                                    uploadArrayImages(title: title, category: category, price: price, description: description, address: address, phone: phone)
                                }else{
                                    self.showAlert("You have not selected photos to upload!")
                                    return
                                }
                            }else {
                                self.showAlert("You have not choose category")
                                return
                            }
                        }else{
                            self.showAlert("You have not filled out the description!")
                            return
                        }
                    }else{
                        
                        self.showAlert("You have not filled out the address!")
                        return
                    }
                }else{
                    self.showAlert("You have not filled out the price!")
                    return
                }
            }else{
                self.showAlert("You have not filled out the phone number!!")
                return
            }
        }else{
            print("k co title")
            self.showAlert("You have not filled out the title!")
            return
        }
    }
    
    //CategoryController delegate
    func didSelectCategory(_ mcategory: String) {
            btnCategory.setTitle(mcategory, for: UIControlState())
    }

    func camera(){
                let pickerController = UIImagePickerController()
                pickerController.delegate = self
                pickerController.allowsEditing = true
        
                let alertController = UIAlertController(title: "Add a Picture", message: "Choose From", preferredStyle: .actionSheet)
        
                let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                    pickerController.sourceType = .camera
                    self.present(pickerController, animated: true, completion: nil)
        
                }
                let photosLibraryAction = UIAlertAction(title: "Photos Library", style: .default) { (action) in
                    pickerController.sourceType = .photoLibrary
                    self.present(pickerController, animated: true, completion: nil)
        
                }
        
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
                alertController.addAction(cameraAction)
                alertController.addAction(photosLibraryAction)
                alertController.addAction(cancelAction)
                
                
                present(alertController, animated: true, completion: nil)
    }

    
    func uploadArrayImages(title: String, category: String, price: Int, description: String, address: String, phone : String ){
            for image in arrayImages {
                let id = UUID().uuidString
                for index in 1...self.arrayImages.count{
                let storageRef = FIRStorage.storage().reference().child("topic_images").child("\((user?.uid)!)").child("topic_\(self.txtTitle.text!)_\(id)").child("image\(index).png")
                
                if let uploadData = UIImagePNGRepresentation(image) {
                    
                    storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                        
                        if error != nil {
                            print(error)
                            return
                        }
                        
                        //dowload url off image
                        if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                            
                            //save
                            self.arrayLinkImages.append(profileImageUrl)
                            if self.arrayLinkImages.count == self.arrayImages.count {
                                
                                //push data to firebase database
                                self.writeData(title: title, category: category, price: price, description: description, address: address, phone: phone)
                            }
                        }
                    })
                }
                }
            }

    }
    
    func writeData(title: String, category: String, price: Int, description: String, address: String, phone : String ) {
        if let userID = user?.uid {
            let date = NSDate()
            let time = "\(date)"
            let Topic = TopicModel(userID: userID, title: title, category: category, price: price, description: description, phone: phone, images: self.arrayLinkImages,address: address, time: time)
            let topicsRef = ref.child("Topics").childByAutoId()
            topicsRef.setValue(Topic.toDictionary())
            LoadingOverlay.shared.hideOverlayView()
            self.showAlertHome("Add Topic Complete. Do you want add topic more!")
            
        } else {
            self.showAlert("You need sign in again!")
        }

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
                var selectedImageFromPicker: UIImage?
        
                if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
                    selectedImageFromPicker = editedImage
                } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
        
                    selectedImageFromPicker = originalImage
                }
        
                if let selectedImage = selectedImageFromPicker {
                    //save
                    arrayImages.append(selectedImage)

                    if arrayImages.count == 1{
                        self.btnImage2.isHidden = false
                        self.btnImage1.setImage(arrayImages[0], for: .normal)
                    }else if arrayImages.count == 2{
                        self.btnImage3.isHidden = false
                        self.btnImage2.setImage(arrayImages[1], for: .normal)
                    }else if arrayImages.count == 3{
                        self.btnImage4.isHidden = false
                        self.btnImage3.setImage(arrayImages[2], for: .normal)
                    }else if arrayImages.count == 4{
                        self.btnImage4.setImage(arrayImages[3], for: .normal)
                        print(arrayImages)
                    }
                }
                
                dismiss(animated: true, completion: nil)
    }
    
    func showAlert(_ message: String){
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }
    func showAlertHome(_ message: String){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancer",style: .default){ action -> Void in
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
            self.navigationController?.pushViewController(vc, animated: true)
            
        })
        self.present(alert, animated: true, completion: nil)
    }
    
}
extension PostAddController {
    func userInterface(){
        
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 5, height: 0))
        let paddingView1 = UIView(frame:CGRect(x: 0, y: 0, width: 5, height: 0))
        let paddingView2 = UIView(frame:CGRect(x: 0, y: 0, width: 5, height: 0))
        let paddingView3 = UIView(frame:CGRect(x: 0, y: 0, width: 5, height: 0))
        let paddingView4 = UIView(frame:CGRect(x: 0, y: 0, width: 5, height: 0))
        
        btnCategory.backgroundColor = UIColor.clear
        btnCategory.layer.borderWidth = 1
        btnCategory.layer.borderColor = UIColor.lightGray.cgColor
        txtPhone.layer.borderWidth = 1
        txtPhone.layer.borderColor = UIColor.lightGray.cgColor
        txtPhone.leftView = paddingView
        txtPrice.layer.borderWidth = 1
        txtPrice.layer.borderColor =  UIColor.lightGray.cgColor
        txtPrice.leftView = paddingView1
        txtTitle.layer.borderWidth = 1
        txtTitle.layer.borderColor = UIColor.lightGray.cgColor
        txtTitle.leftView = paddingView2
        txtAddress.layer.borderWidth = 1
        txtAddress.layer.borderColor = UIColor.lightGray.cgColor
        txtAddress.leftView = paddingView3
        txtDescription.layer.borderWidth = 1
        txtDescription.layer.borderColor = UIColor.lightGray.cgColor
        txtDescription.leftView = paddingView4
        
        //dismiskeybroad
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        btnImage2.isHidden = true
        btnImage3.isHidden = true
        btnImage4.isHidden = true
        arrayImages = []
        arrayLinkImages = []
        print(self.txtTitle.text)

    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        
    }
}
