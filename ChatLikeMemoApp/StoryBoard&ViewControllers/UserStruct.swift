//
//  User.swift
//  ChatLikeMemoApp
//
//  Created by Naoyuki Umeda on 2021/08/08.
//

import UIKit
import Firebase


struct  User {
    let name : String
    let createdAt : Timestamp
    let email : String
    var uid : String?
    
    init(dic: [String: Any]){
        self.name = dic["name"] as! String
        self.createdAt = dic["createdAt"] as! Timestamp
        self.email = dic["email"] as! String
    }
}
