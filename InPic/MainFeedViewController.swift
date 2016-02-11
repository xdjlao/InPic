//
//  MainFeedTableViewController.swift
//  InPic
//
//  Created by Jerry on 2/4/16.
//  Copyright © 2016 Ethan Thomas. All rights reserved.
//

import UIKit
import Firebase
import ImagePicker
import Toucan

class MainFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ImagePickerDelegate {
    
    var postArray = [Post]()
    let imagePickerController = ImagePickerController()
    var currentUser:User?
    let image = Photo()
    var returnedImage = UIImage()
    //    var returnedString = ""
    
    //    var didLoadImages: Bool!
    
    let loggedInUser = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 360
    }
    
    override func viewWillAppear(animated: Bool) {
        //        DataService.dataService.USER_REF.childByAppendingPath(self.loggedInUser.stringForKey("uid")).observeEventType(.Value, withBlock: { response in
        //            let username = response.value.valueForKey("username") as? String
        //
        //            self.currentUser = User(uid: response.key, username: username!)
        //            if let newAvatar = response.value.valueForKey("avatar") {
        //                let avatarData = NSData(base64EncodedString: newAvatar as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        //                let avatarImage = UIImage(data: avatarData!)
        //                self.currentUser?.avatar = avatarImage!
        //            }
        
        DataService.dataService.POST_REF.observeEventType(.ChildAdded, withBlock: { (data) in
            
            let ref = DataService.dataService.PHOTO_REF.childByAppendingPath(data.key)
            
            ref.observeEventType(.Value, withBlock: { snapshot in
                if let snaps = snapshot.children.allObjects as? [FDataSnapshot] {
                    if snaps.count > 0 {
                        let snap = snaps[0]
                        if let imageString = snap.value["string"] as? String {
                            let imageData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                            let backImage = UIImage(data: imageData!)
                            let post = Post()
                            // post.image = backImage!
                            if let time = data.value.objectForKey("timestamp") {
                                post.timestamp = String(time)
                            }
                            // print(post.timestamp!)
                            if let caption = data.value.objectForKey("caption") {
                                post.caption = caption as? String
                            }
                            
                            let photo = Photo()
                            photo.image = backImage
                            post.photo = photo
                            
                            self.postArray.append(post)
                            self.sortByTimestamp()
                            dispatch_async(dispatch_get_main_queue()){
                                self.tableView.reloadData()
                                // print("Reloaded table view")
                                // print(self.postArray.count)
                            }
                        }
                    }
                }
                
                }, withCancelBlock: { error in
                    print(error)
            })
            
            }, withCancelBlock: { (error) in
        })
        //        })
        //        DataService.dataService.BASE_REF.keepSynced(true)
    }
    
    func sortByTimestamp() {
        self.postArray.sortInPlace({$0.timestamp > $1.timestamp})
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.loggedInUser.stringForKey("uid") == nil {
            self.performSegueWithIdentifier("goLogInSegue", sender: nil)
        } else {
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return (self.postArray.post.count) ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MainFeedCell", forIndexPath: indexPath) as! MainFeedTableViewCell
        
        // Configure the cell...
        if let currentUser = self.user {
            if currentUser.post.count > 0 {
                cell.cellImageView.image = currentUser.post[indexPath.section].photo?.image
            }
        }
        
        return cell
    }
    
    @IBAction func onUploadButtonPressed(sender: UIBarButtonItem) {
        self.imagePickerController.delegate = self
        self.imagePickerController.imageLimit = 1
        presentViewController(self.imagePickerController, animated: true, completion: nil)
    }
    
    
    func wrapperDidPress(images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(images: [UIImage]) {
        self.imagePickerController.dismissViewControllerAnimated(true) { () -> Void in
            if images.count > 0 {
                self.performSegueWithIdentifier("postImageSegue", sender: images[0])
                
            }
        }
    }
    
    @IBAction func unwindToMain(sender: UIStoryboardSegue) {
        
    }
    
    func cancelButtonDidPress() {
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.95)
        
        // Add a UILabel for the username here
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        imageView.image = self.getRoundImage((self.user?.post[section].photo?.image)!)
        headerView.addSubview(imageView)
        
        let label = UILabel(frame: CGRect(x:50, y:10, width: self.view.frame.width - imageView.frame.width - 20, height: 30))
        
        label.font.fontWithSize(CGFloat(8))
        label.textAlignment = .Left
        label.text = self.user!.username
        headerView.addSubview(label)
        
        return headerView
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func getRoundImage(image: UIImage) -> UIImage {
        let resizedImage = Toucan(image: image).resize(CGSize(width: 30, height: 30), fitMode: Toucan.Resize.FitMode.Crop).image
        let roundedImage = Toucan(image: resizedImage).maskWithEllipse().image
        return roundedImage
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "postImageSegue" {
            let destination = segue.destinationViewController as! PostImageViewController
            destination.postImage = sender as? UIImage
        } else {
            if segue.identifier == "commentSegue" || segue.identifier == "likeSegue" {
                if let buttonPoint = sender!.center {
                    if let indexPath = self.tableView.indexPathForRowAtPoint(buttonPoint) {
                        let post = self.user?.post[indexPath.section]
                        if segue.identifier == "commentSegue" {
                            let commentsVC = segue.destinationViewController as! CommentsViewController
                            commentsVC.post = post
                        } else if segue.identifier == "likeSegue" {
                            let likesVC = segue.destinationViewController as! CommentsViewController
                            likesVC.post = post
                        }
                    }
                    
                }
            }
            
        }
    }
}
