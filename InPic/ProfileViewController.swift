//
//  ProfileViewController.swift
//  InPic
//
//  Created by Jerry on 2/4/16.
//  Copyright © 2016 Ethan Thomas. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var buttonImage: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        self.buttonImage.setImage(UIImage(named: "image"), forState: UIControlState.Normal)    }
    
    
    @IBAction func editProfilePicTapped(sender: AnyObject) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func onLogOutTapped(sender: UIBarButtonItem) {
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.buttonImage.imageView!.contentMode = .ScaleAspectFit
            self.buttonImage.setImage(pickedImage, forState: UIControlState.Normal)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
