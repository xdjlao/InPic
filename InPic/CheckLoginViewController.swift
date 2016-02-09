//
//  CheckLoginViewController.swift
//  InPic
//
//  Created by Jerry on 2/9/16.
//  Copyright © 2016 Ethan Thomas. All rights reserved.
//

import UIKit

class CheckLoginViewController: UITabBarController {
    
    let loggedInUser = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        if let _ = self.loggedInUser.stringForKey("user") {
            
        } else {
            self.performSegueWithIdentifier("goLogInSegue", sender: nil)
        }
    }

}
