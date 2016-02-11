//
//  ProfileViewController.swift
//  InPic
//
//  Created by Jerry on 2/4/16.
//  Copyright © 2016 Ethan Thomas. All rights reserved.
//

import UIKit
import ImagePicker
import Toucan

class ProfileViewController: UIViewController, ImagePickerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = ImagePickerController()
    
    @IBOutlet weak var buttonImage: UIButton!
    @IBOutlet weak var topStackView: UIStackView!
    
    let loggedInUser = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.imagePicker.delegate = self
        
        self.buttonImage.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        let navbarHeight = self.navigationController?.navigationBar.frame.height
        self.topStackView.frame = CGRectMake(0, navbarHeight!, self.view.frame.width, self.buttonImage.frame.width)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        let ref = DataService.dataService.USER_REF.childByAppendingPath(self.loggedInUser.objectForKey("uid") as! String)
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            if let snap = snapshot.value.valueForKey("avatar") as? String {
                let imageData = NSData(base64EncodedString: snap, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let backImage = UIImage(data: imageData!)
                    let roundedImage = self.getRoundImage(backImage!)
                    self.buttonImage.setImage(roundedImage, forState: UIControlState.Normal)
                })
            }
            else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let defaultImg = UIImage(named: "image")
                    let roundedImage = self.getRoundImage(defaultImg!)
                    self.buttonImage.setImage(roundedImage, forState: UIControlState.Normal)
                })
            }
        })
    }
    
    
    @IBAction func editProfilePicTapped(sender: AnyObject) {
        
        //        imagePicker.allowsEditing = true
        //        imagePicker.sourceType = .PhotoLibrary
        
        //        presentViewController(imagePicker, animated: true, completion: nil)
        self.imagePicker.delegate = self
        self.imagePicker.imageLimit = 1
        presentViewController(self.imagePicker, animated: true, completion: nil)
        
    }
    
    func wrapperDidPress(images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(images: [UIImage]) {
        self.imagePicker.dismissViewControllerAnimated(true) { () -> Void in
            if images.count > 0 {
                let image = images[0]
                let roundedImage = self.getRoundImage(image)
                
                let imageData: NSData = UIImageJPEGRepresentation(roundedImage, 1.0)!
                let base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
                DataService.dataService.updateProfileImage(base64String)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.buttonImage.imageView!.contentMode = .ScaleAspectFit
                    self.buttonImage.setImage(roundedImage, forState: UIControlState.Normal)
                })
                
            }
        }
    }
    
    func cancelButtonDidPress() {
    }
    
//    DataService.dataService.POST_REF.childByAppendingPath(self.loggedInUser.stringForKey("uid")).queryOrderedByChild("timestamp").observeEventType(.ChildAdded, withBlock: { (data) in
//    
//    let ref = DataService.dataService.PHOTO_REF.childByAppendingPath(data.key)
//    
//    ref.observeEventType(.Value, withBlock: { snapshot in
//    if let snaps = snapshot.children.allObjects as? [FDataSnapshot] {
//    if snaps.count > 0 {
//    let snap = snaps[0]
//    if let imageString = snap.value["string"] as? String {
//    let imageData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
//    let backImage = UIImage(data: imageData!)
//    let post = Post()
//    // post.image = backImage!
//    if let time = data.value.objectForKey("timestamp") {
//    post.timestamp = String(time)
//    }
//    // print(post.timestamp!)
//    if let caption = data.value.objectForKey("caption") {
//    post.caption = caption as? String
//    }
//    
//    let photo = Photo()
//    photo.image = backImage
//    post.photo = photo
//    
//    self.user?.post.append(post)
//    self.sortByTimestamp()
//    dispatch_async(dispatch_get_main_queue()){
//    self.tableView.reloadData()
//    // print("Reloaded table view")
//    // print(self.postArray.count)
//    }
//    }
//    }
//    }
//    
//    }, withCancelBlock: { error in
//    print(error)
//    })
//    
//    }, withCancelBlock: { (error) in
//    })
//})
//DataService.dataService.BASE_REF.keepSynced(true)

    func getRoundImage(image: UIImage) -> UIImage {
        let resizedImage = Toucan(image: image).resize(CGSize(width: 300, height: 300), fitMode: Toucan.Resize.FitMode.Crop).image
        let roundedImage = Toucan(image: resizedImage).maskWithEllipse().image
        return roundedImage
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logoutSegue" {
            let appDomain = NSBundle.mainBundle().bundleIdentifier
            NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        }
    }

}
