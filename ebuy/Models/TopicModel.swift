//
//  ProductModel.swift
//  ebuy
//
//  Created by Nguyen Tuan Anh on 6/20/17.
//  Copyright © 2017 Anh Tuan Nguyen. All rights reserved.
//

import Foundation
import UIKit

class TopicModel {
    var topicKey: String?
    var userID: String?
    var title: String?
    var address: String?
    var time: String?
    var category: String?
    var description: String?
    var images: [String]?
    var phone: String?
    var price: Int?

    

    init(userID: String, title: String, category: String, price: Int, description: String, phone: String,images: [String], address: String, time: String){
        self.userID = userID
        self.title = title
        self.category = category
        self.description = description
        self.images = images
        self.phone = phone
        self.price = price
        self.address = address
        self.time = time
    }
    init(key: String, dictionary: Dictionary<String,AnyObject>) {
        self.topicKey = key
        if let userID = dictionary["userID"] as? String {
            self.userID = userID
        }
        if let title = dictionary["title"] as? String {
            self.title = title
        }
        if let category = dictionary["category"] as? String {
            self.category = category
        }
        if let description = dictionary["description"] as? String {
            self.description = description
        }
        if let images = dictionary["images"] as? [String] {
            self.images = images
        }
        if let phone = dictionary["phone"] as? String {
            self.phone = phone
        }
        if let pice = dictionary["pice"] as? Int {
            self.price = pice
        }
        if let address = dictionary["address"] as? String {
            self.address = address
        }
        if let time = dictionary["time"] as? String {
            self.time = time
        }
    }
    
    func toDictionary() -> [String : Any] {
        return ["userID":userID,  "title":title,"category": category,"description": description ,"images":images,"phone":phone,"pice":price, "address": address, "time": time ]
    }

}
