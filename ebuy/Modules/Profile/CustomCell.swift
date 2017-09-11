//
//  CustomCell.swift
//  ebuy
//
//  Created by Nguyen Tuan Anh on 6/12/17.
//  Copyright © 2017 Anh Tuan Nguyen. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    
    @IBOutlet weak var imgPhoto: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        circularImage(imgPhoto)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
extension CustomCell{
    
    func circularImage(_ photoImageView: UIImageView?)
    {
        photoImageView!.layer.frame = photoImageView!.layer.frame.insetBy(dx: 0, dy: 0)
        
        photoImageView!.layer.borderWidth = 0
        
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
