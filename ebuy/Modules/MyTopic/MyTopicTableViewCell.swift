//
//  MyTopicTableViewCell.swift
//  ebuy
//
//  Created by Nguyen Tuan Anh on 6/12/17.
//  Copyright © 2017 Anh Tuan Nguyen. All rights reserved.
//

import Foundation
import UIKit

class MyTopicTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var viewCell: UIView!
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var label4: UILabel!
    
    @IBOutlet weak var imageCell: UIImageView!
    
    var topic: TopicModel!
    
    func configureCell(_ topic: TopicModel) {
        self.topic = topic
        self.label1.text = topic.title
        self.label2.text = topic.address
        if let pri = topic.price{
            self.label4.text = "\(String(describing: pri)) Đồng"
        }
        
        self.label3.text = topic.description
        
        if let checkedUrl = URL(string: (topic.images?[0])!) {
            imageCell?.contentMode = .scaleToFill
            downloadImage(url: checkedUrl)
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
                self.imageCell?.image = UIImage(data: data)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        viewCell.layer.cornerRadius = 4
        
        viewCell.layer.shadowOpacity = 0.1
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func setCell(_ label1: String,label2:String,label3:String,label4:String,image :String){
        self.label1.text = label1
        
        self.label2.text = label2
        
        self.label3.text = label3
        
        self.label4.text = label4
        
        self.imageCell.image = UIImage(named: image)
        
    }
}
