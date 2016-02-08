//
//  UploadPostViewController.swift
//  InPic
//
//  Created by Jerry on 2/8/16.
//  Copyright © 2016 Ethan Thomas. All rights reserved.
//

import UIKit
import ImagePicker

class UploadPostViewController: UIViewController, ImagePickerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func wrapperDidPress(images: [UIImage]) {}
    func doneButtonDidPress(images: [UIImage]) {}
    func cancelButtonDidPress() {}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
