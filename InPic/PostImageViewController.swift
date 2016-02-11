//
//  PostImageViewController.swift
//  InPic
//
//  Created by Jerry on 2/8/16.
//  Copyright © 2016 Ethan Thomas. All rights reserved.
//

import UIKit
import Toucan

class PostImageViewController: UIViewController {
    
    var postImage: UIImage?

    var base64String: String?

    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var bgImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBarHidden = true
        self.tabBarController?.tabBar.hidden = true
        // Do any additional setup after loading the view.
        self.bgImageView.image = postImage
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "doneButtonPressed")
        self.navigationItem.rightBarButtonItem = doneButton
        
        let leftPaddingView = UIView(frame: CGRectMake(0,0,10,self.captionTextField.frame.height))
        self.captionTextField.leftView = leftPaddingView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func doneButtonPressed()
    {
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            let croppedImage = self.getCroppedImage(self.postImage!)
            let imageData: NSData = UIImageJPEGRepresentation(croppedImage, 1.0)!
            self.base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
            let timestamp = NSDate(timeIntervalSinceNow: NSTimeInterval())
            //DataService.dataService.createNewPhoto(self.base64String as String, uid: DataService.dataService.BASE_REF.authData.uid as String, timestamp: "\(timestamp)")
            DataService.dataService.createNewPost(self.captionTextField.text!, timestamp: "\(timestamp)", photo: self.base64String!)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func getCroppedImage(image: UIImage) -> UIImage {
        let resizedImage = Toucan(image: image).resize(CGSize(width: 1080, height: 1080), fitMode: Toucan.Resize.FitMode.Crop).image
        return resizedImage
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
