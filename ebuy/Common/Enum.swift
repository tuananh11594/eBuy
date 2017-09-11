//
//  Enum.swift
//  ebuy
//
//  Created by Nguyen Tuan Anh on 6/12/17.
//  Copyright © 2017 Anh Tuan Nguyen. All rights reserved.
//

import Foundation

enum TopicCategory : String {
    case All = "All"
    
    case House = "House"
    
    case Computer = "Computer"
    
    case BikeCar = "BikeCar"
    
    case Mobile = "Mobile"
    
    case Pet = "Pet"
    
    case Fashion = "Fashion"
    
    case Sport = "Sport"
    
    
    
    static func allValues() -> [TopicCategory] {
        return [.All, .House, .Computer, .All, .BikeCar, .Mobile, .Pet,.Fashion,.Sport]
    }
    
    static var allCategories : [String] {
        return ["House","Computer","BikeCar","Mobile","Pet","Fashion","Sport"]
    }
    static func getAllCategories() -> [String]{
        return allCategories
    }
}
