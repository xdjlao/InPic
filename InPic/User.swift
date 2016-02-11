//
//  User.swift
//  InPic
//
//  Created by Jerry on 2/4/16.
//  Copyright © 2016 Ethan Thomas. All rights reserved.
//

import Foundation
import UIKit

class User {
    var uid: String
    var username: String
    var avatar: UIImage = UIImage(named: "image")!
    var post: [Post]
    
    init(uid: String, username: String)
    {
        self.uid = uid
        self.username = username
        self.post = []
        
    }
}
