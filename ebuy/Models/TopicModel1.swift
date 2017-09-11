//
//  TopicModel.swift
//  ebuy
//
//  Created by Nguyen Tuan Anh on 6/12/17.
//  Copyright © 2017 Anh Tuan Nguyen. All rights reserved.
//

import Foundation
import UIKit

class TopicModel1 {
    
    var category: TopicCategory
    
    var title : String
    
    var address: String
    
    var description: String
    
    var price: Int
    
    var image: String
    
    init(category: TopicCategory,title : String, address: String, description: String,price: Int , image: String){
        self.category = category
        self.title = title
        self.image = image
        self.address = address
        self.description = description
        self.price = price
    }
    
    
}
struct ProductModel {
    var title : String
    var address : String
    var description : String
    var price : String
    var image : String
}
