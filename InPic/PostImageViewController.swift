//
//  PostImageViewController.swift
//  InPic
//
//  Created by Jerry on 2/8/16.
//  Copyright © 2016 Ethan Thomas. All rights reserved.
//

import UIKit

class PostImageViewController: UIViewController {
    
    var postImage:UIImage?

    @IBOutlet weak var bgImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        // Do any additional setup after loading the view.
        self.bgImageView.image = postImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
