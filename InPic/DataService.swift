//
//  DataService.swift
//  InPic
//
//  Created by Ethan Thomas on 2/8/16.
//  Copyright © 2016 Ethan Thomas. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let dataService = DataService()

    private var _BASE_REF = Firebase(url: "\(BASE_URL)")
    private var _USER_REF = Firebase(url: "\(BASE_URL)/users")
    private var _PHOTO_REF = Firebase(url: "\(BASE_URL)/photos")

    var BASE_REF: Firebase {
        return _BASE_REF
    }

    var USER_REF: Firebase {
        return _USER_REF
    }

    var PHOTO_REF: Firebase {
        return _PHOTO_REF
    }

    var CURRENT_USER_REF: Firebase {
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String

        let currentUser = Firebase(url: "\(BASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)

        return currentUser!
    }

    func createNewAccount(uid: String, user: Dictionary<String, String>) {
        USER_REF.childByAppendingPath(uid).setValue(user)
    }

    func createNewPhoto(photo: String, uid: String, timestamp: String) {
        let photos = ["string": photo, "uid": uid, "timestamp": timestamp]
        PHOTO_REF.childByAutoId().setValue(photos)
    }
}
