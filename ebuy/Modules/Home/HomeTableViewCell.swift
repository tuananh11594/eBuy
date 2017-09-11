//
//  HomeTableViewCell.swift
//  ebuy
//
//  Created by Nguyen Tuan Anh on 6/12/17.
//  Copyright © 2017 Anh Tuan Nguyen. All rights reserved.
//

import UIKit
import Firebase

class HomeTableViewCell: UITableViewCell {
    

    @IBOutlet weak var txtTitle: UILabel!
    
    @IBOutlet weak var txtAddress: UILabel!

    @IBOutlet weak var txtDescription: UILabel!

    @IBOutlet weak var txtPrice: UILabel!
    
    @IBOutlet weak var imageCell: UIImageView!
    
    @IBOutlet weak var viewCell: UIView!
    
    var topic: TopicModel!
    
    func configureCell(_ topic: TopicModel) {
        self.topic = topic
        self.txtTitle.text = topic.title
        self.txtAddress.text = topic.address
        if let pri = topic.price{
        self.txtPrice.text = "\(String(describing: pri)) Đồng"
        }

        self.txtDescription.text = topic.description

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
    
    
}
