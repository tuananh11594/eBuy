//
//  APIManager.swift
//  ebuy
//
//  Created by Anh Tuan Nguyen on 6/9/17.
//  Copyright © 2017 Anh Tuan Nguyen. All rights reserved.
//

import Foundation
import CoreData
import Firebase

class APIMananger: NSObject {
//    var dataDict = [String: [TopicModel]]()
    
//    var category = [String]()
    
//    var listOfTopics = [TopicModel]()
    
    static let sharedInstance = APIMananger()
    
    func registerUserIntoDatabaseWithUID(_ uid: String, user: Dictionary<String, String>){
        let usersReference = Constants.URL.baseURL.child("users").child(uid)
        
        usersReference.setValue(user)
    }
}
