//
//  UserModel.swift
//  ebuy
//
//  Created by Nguyen Tuan Anh on 6/27/17.
//  Copyright © 2017 Anh Tuan Nguyen. All rights reserved.
//

import Foundation

class UserModel {
    var fullName: String
    var email: String
    var avatar: String
    
    init(fullName: String, email: String, avatar: String) {
        self.fullName = fullName
        self.email = email
        self.avatar = avatar
    }
    
    func toDictionary() -> [String: String] {
        return ["fullName":fullName, "email": email, "avatar": avatar]
    }
}
