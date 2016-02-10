//
//  ProfileViewController.swift
//  InPic
//
//  Created by Jerry on 2/4/16.
//  Copyright © 2016 Ethan Thomas. All rights reserved.
//

import UIKit
import ImagePicker

class ProfileViewController: UIViewController, ImagePickerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = ImagePickerController()
    
    @IBOutlet weak var buttonImage: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.imagePicker.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        self.buttonImage.setImage(UIImage(named: "image"), forState: UIControlState.Normal)    }
    
    
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
                self.buttonImage.imageView!.contentMode = .ScaleAspectFit
                self.buttonImage.setImage(images[0], forState: UIControlState.Normal)
            }
        }
    }
    
    func cancelButtonDidPress() {
    }
    
    //    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    //        dismissViewControllerAnimated(true, completion: nil)
    //    }
    //
    //    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    //        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
    //            self.buttonImage.imageView!.contentMode = .ScaleAspectFit
    //            self.buttonImage.setImage(pickedImage, forState: UIControlState.Normal)
    //        }
    //        
    //        dismissViewControllerAnimated(true, completion: nil)
    //        
    //    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logoutSegue" {
            let appDomain = NSBundle.mainBundle().bundleIdentifier
            NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        }
    }
    
}
