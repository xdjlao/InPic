//
//  CreateAccountViewController.swift
//  InPic
//
//  Created by Ethan Thomas on 2/8/16.
//  Copyright © 2016 Ethan Thomas. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet var usernameText: UITextField!
    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    let loggedInUser = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func backToLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func createAccount(sender: AnyObject) {
        let email = emailText.text
        let username = usernameText.text
        let password = passwordText.text

        if email != "" && username != "" && password != "" {
            DataService.dataService.BASE_REF.createUser(email, password: password, withValueCompletionBlock: { (error, result) in
                if error != nil {
                    let alert = UIAlertController(title: "Sorry!", message: error.localizedDescription, preferredStyle: .Alert)
                    let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(ok)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    let userID = result["uid"] as? String
                    DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: { (newError, authData) in

                        if error != nil {
                            let newAlert = UIAlertController(title: "Sorry!", message: newError.localizedDescription, preferredStyle: .Alert)
                            let newOk = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            newAlert.addAction(newOk)
                            self.presentViewController(newAlert, animated: true, completion: nil)
                        } else {
                            DataService.dataService.createNewAccount(userID!, username: username!, email: email!)
                            self.loggedInUser.setValue(userID, forKey: "uid")
                            self.performSegueWithIdentifier("createToMain", sender: nil)
                        }
                    })
//
                    
                }
            })
        } else {
            self.showErrorAlert("Sorry!", message: "Be sure to fill in all of the text fields with your user information you'd like to register as!")
        }
    }

    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
