//
//  LeftMenuController.swift
//  ebuy
//
//  Created by Nguyen Tuan Anh on 6/10/17.
//  Copyright © 2017 Anh Tuan Nguyen. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

protocol MenuDelegate: class {
    func hidenLefMenu() -> ()
}

class LeftMenuController: BaseController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: MenuDelegate?
    
    //Before login
    let name1 = ["Login","Topic","Message","Share"]
    
    let image1 = ["login","addtopic","MessageIconTop","share"]
    
    let image11 = ["login1","addtopic1","message1","share1"]
    
    //After login
    let name2 = ["Profile","Topic","Message","Share"]
    
    let image2 = ["profile","addtopic","message","share"]
    
    let image22 = ["profile1","addtopic1","message1","share1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = hexStringToUIColor("#333a43")
        
        self.tableView.separatorStyle =  UITableViewCellSeparatorStyle.none
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserDefaults.standard.object(forKey: Constants.NSUSerDefaultKey.Email) == nil{
            return name1.count
        }else{
            return name2.count
        }
    }
    
    func selectRow(_ index: Int){
        delegate?.hidenLefMenu()
        
        if let email = UserDefaults.standard.object(forKey: Constants.NSUSerDefaultKey.Email) {
            switch index {
            case 0:
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let vc = mainStoryboard.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
                
                self.navigationController?.pushViewController(vc, animated: true)
                
                self.navigationController?.isNavigationBarHidden = true
                break
            case 1:
                let myTopicViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyTopicController") as! MyTopicController
                
                self.navigationController?.pushViewController(myTopicViewController, animated: true)
                
                break
            case 2:
                print("Phan nay chua lam")
                
                break
            case 3:
                displayShareSheet("eBuy")
                
                break
            default:
                
                break
            }
        }else{
            switch index {
            case 0:
                self.LoginNavigation()
                
                break
            case 1:
                self.showAlert()
                
                break
            case 2:
                self.showAlert()
                
                break
            case 3:
                displayShareSheet("eBuy")
                
                break
            default:
                
                break
            }
        }
    }
    
    func displayShareSheet(_ shareContent:String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: {})
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as! MenuTableViewCell
        
        cell.backgroundColor = UIColor.clear
        
        if UserDefaults.standard.object(forKey: Constants.NSUSerDefaultKey.Email) == nil {
            cell.lblName.text = name1[indexPath.row]
            
            cell.imgView.image = UIImage(named: image1[indexPath.row])
            
        }else {
            cell.lblName.text = name2[indexPath.row]
            
            cell.imgView.image = UIImage(named: image2[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectRow(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        
        cell.lblName.textColor = hexStringToUIColor("#00cd00")
        
        // delegate sender
        if UserDefaults.standard.object(forKey: Constants.NSUSerDefaultKey.Email) == nil {
            cell.imgView.image! = UIImage(named: image11[indexPath.row])!
            
            cell.view.alpha = 1
        }else{
            cell.imgView.image! = UIImage(named: image22[indexPath.row])!
            
            cell.view.alpha = 1
        }
        cell.contentView.backgroundColor = hexStringToUIColor("#282f37")
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        
        cell.lblName.textColor = hexStringToUIColor("#ffffff")
        
        if UserDefaults.standard.object(forKey: Constants.NSUSerDefaultKey.Email) == nil{
            cell.imgView.image! = UIImage(named: image1[indexPath.row])!
            
            cell.view.alpha = 0
        }else{
            cell.imgView.image! = UIImage(named: image2[indexPath.row])!
            
            cell.view.alpha = 0
        }
        cell.contentView.backgroundColor = .clear
    }
    
}

/*
 // MARK: - hexcolor, reSize image
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */

extension LeftMenuController{
    
    func imageResize (_ image:UIImage, sizeChange:CGSize)-> UIImage{
        let hasAlpha = true
        
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        return scaledImage!
    }
    
    func showAlert(){
        let alert = UIAlertController(title: nil, message: "Please log in.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK",style: .default, handler: { action in
            self.LoginNavigation()
            
        }))
        alert.addAction(UIAlertAction(title: "CANCEL",style: .cancel, handler:nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func LoginNavigation(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "SignInController") as! SignInController
        self.navigationController?.pushViewController(vc, animated: true)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
}
