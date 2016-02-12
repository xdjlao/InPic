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
    private var _POST_REF = Firebase(url: "\(BASE_URL)/posts")

    var BASE_REF: Firebase {
        return _BASE_REF
    }

    var USER_REF: Firebase {
        return _USER_REF
    }

    var PHOTO_REF: Firebase {
        return _PHOTO_REF
    }
    
    var POST_REF: Firebase {
        return _POST_REF
    }

    var CURRENT_USER_REF: Firebase {
        let userID = (NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String)!
        let currentUser = Firebase(url: "\(BASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)

        return currentUser!
    }

    func createNewAccount(uid: String, username: String, email: String) {
        let user = ["username":username, "email":email]
        USER_REF.childByAppendingPath(uid).setValue(user)
    }
    
    func createNewPost(caption: String, timestamp: String, photo: String) {
        let userID = (NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String)!
        let posts = ["caption":caption, "timestamp":timestamp, "userID":userID]
        POST_REF.childByAutoId().setValue(posts, withCompletionBlock: {
            (error:NSError?, ref:Firebase!) in
            if (error == nil) {
                let postd = [ref.key: "true"]
                self.USER_REF.childByAppendingPath(userID).childByAppendingPath("posts").updateChildValues(postd)
                self.createNewPhoto(photo, postid: ref.key)
            }
        })
    }
    
    func createNewPhoto(photo: String, postid: String) {
        let photos = ["string": photo, "postID": postid]
        PHOTO_REF.childByAutoId().setValue(photos, withCompletionBlock: {
            (error:NSError?, ref:Firebase!) in
            if (error == nil) {
                self.updatePost(ref.key, postid: postid)
            }
        })
    }
    
    func updateProfileImage(photo: String) {
        let avatar = ["avatar": photo]
        let userID = (NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String)!
        USER_REF.childByAppendingPath(userID).updateChildValues(avatar)
    }
    
    func updatePost(photoid: String, postid: String) {
        let post = ["photoID":photoid]
        POST_REF.childByAppendingPath(postid).updateChildValues(post)
    }
}
