//
//  MenuTableViewCell.swift
//  ebuy
//
//  Created by Nguyen Tuan Anh on 6/12/17.
//  Copyright © 2017 Anh Tuan Nguyen. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setCell(_ name:String,image:String){
        self.lblName.text = name
        
        self.imgView.image = UIImage(named: image)
    }
}
