//
//  ProfileViewController.swift
//  InPic
//
//  Created by Jerry on 2/4/16.
//  Copyright © 2016 Ethan Thomas. All rights reserved.
//

import UIKit
import ImagePicker

class ProfileViewController: UIViewController, ImagePickerDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    let imagePicker = ImagePickerController()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func editProfilePicTapped(sender: AnyObject) {
        
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
        
        
        
        
        
    }
    
    
    func wrapperDidPress(images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(images: [UIImage]) { dismissViewControllerAnimated(true) { () -> Void in
        self.profileImage.image = images.first
        }
        print(images)
    }
    
    func cancelButtonDidPress() {
        
}

}
