//
//  ListFullViewController.swift
//  ebuy
//
//  Created by Anh Tuan Nguyen on 6/6/17.
//  Copyright © 2017 Anh Tuan Nguyen. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class ListFullController: UIViewController, UIApplicationDelegate, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var btnCallPhone: UIButton!
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var Btn0: UIButton!
    @IBOutlet weak var Btn1: UIButton!
    @IBOutlet weak var Btn2: UIButton!
    @IBOutlet weak var Btn3: UIButton!
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var txtPrice: UILabel!
    @IBOutlet weak var txtAddress: UILabel!
    @IBOutlet weak var txtDescription: UILabel!
    @IBOutlet weak var txtTime: UILabel!
    
    var linkImages : [String] = []
    var images: [UIImage] = []
    var phone: String = ""
    var currentIndex=0
    var titleListFull = ""
    var price = ""
    var address = ""
    var descriptionListFull: String = ""
    var time = ""
    
    
    @IBAction func Btn0(_ sender: AnyObject) {
        [Btn0, Btn1, Btn2, Btn3].forEach{$0.layer.borderWidth = 0}
        sender.layer.borderWidth = 2
        sender.layer.borderColor = UIColor.gray.cgColor
        if images.count > 0 {
            self.img1.image = images[0]
        }
    }
    
    @IBAction func btn1(_ sender: UIButton) {
        [Btn0, Btn1, Btn2, Btn3].forEach{$0.layer.borderWidth = 0}
        sender.layer.borderWidth = 2
        sender.layer.borderColor = UIColor.gray.cgColor
        if images.count == 2 {
            self.img1.image = images[1]
        }
    }
    
    @IBAction func btn2(_ sender: UIButton) {
        [Btn0, Btn1, Btn2, Btn3].forEach{$0.layer.borderWidth = 0}
        sender.layer.borderWidth = 2
        sender.layer.borderColor = UIColor.gray.cgColor
        if images.count == 3 {
            self.img1.image = images[2]
        }
    }
    @IBAction func btn3(_ sender: UIButton) {
        [Btn0, Btn1, Btn2, Btn3].forEach{$0.layer.borderWidth = 0}
        sender.layer.borderWidth = 2
        sender.layer.borderColor = UIColor.gray.cgColor
        if images.count == 4 {
            self.img1.image = images[3]
        }
    }
    @IBAction func UiBtShare(_ sender: AnyObject) {
        
        img1.resignFirstResponder()
        displayShareSheet(img1.description)
    }
    
    @IBAction func sendMessage(_ sender: AnyObject) {
        let messageVC = MFMessageComposeViewController()
        
        messageVC.body = "Hello I want to buy your product!";
        messageVC.recipients = ["\(self.phone)"]
        messageVC.messageComposeDelegate = self
        
        self.present(messageVC, animated: false, completion: nil)
    }
    
    @IBAction func btnCallPhone(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: "tel://\(self.phone)")!)
    }
    
    @IBAction func but1pre(_ sender: AnyObject) {
        
        if currentIndex > 0 {
            
            currentIndex  -= 1
                        img1.image = images[currentIndex]
            
            
        } else{
            currentIndex = 0
                        img1.image = images[currentIndex]
        }
    [Btn0, Btn1, Btn2, Btn3].forEach{$0.layer.borderWidth = 0}
        
    }
    
    @IBAction func but2next(_ sender: AnyObject) {
        
        if currentIndex<images.count-1  {
            
            currentIndex += 1
                        img1.image = images[currentIndex]
            
        } else{
            currentIndex = 0
                        img1.image = images[currentIndex]
            
        }
    [Btn0, Btn1, Btn2, Btn3].forEach{$0.layer.borderWidth = 0}
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        loadImagesFromlinkImage()
        print(linkImages)
        
    }
    func setBackgroundOfButton(){
        
        if images.count == 1 {
            self.Btn0.setImage(images[0], for: .normal)
        }
        if images.count == 2 {
            self.Btn1.setImage(images[1], for: .normal)
        }
        if images.count == 3 {
            self.Btn2.setImage(images[2], for: .normal)
        }
        if images.count == 4 {
            self.Btn3.setImage(images[3], for: .normal)
        }
    }
    
    func config(){
        viewCell.layer.cornerRadius = 4
        viewCell.layer.shadowOpacity = 0.1
        self.txtTitle.text = titleListFull
        self.txtAddress.text = address
        self.txtPrice.text = price
        self.txtDescription.text = descriptionListFull
        self.txtTime.text = time

    }
    
    func loadImagesFromlinkImage(){
        for link in linkImages {
            if let checkedUrl = URL(string: link) {
                img1?.contentMode = .scaleToFill
                downloadImage(url: checkedUrl)

            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                let image = UIImage(data: data)
                self.images.append(image!)
                self.img1.image = self.images[0]
                self.setBackgroundOfButton()
            }
        }
    }


    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        default:
            break;
        }
    }
    
    func displayShareSheet(_ shareContent:String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
    

}
  
