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
    
    let loggedInUser = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 360
    }
    
    //    func sortByTimestamp() {
    //        self.postArray.sortInPlace {
    //            $0.timestamp!.compare($1.timestamp!) == .OrderedAscending
    //        }
    //    }
    
    override func viewDidAppear(animated: Bool) {
        if self.loggedInUser.stringForKey("uid") == nil {
            self.performSegueWithIdentifier("goLogInSegue", sender: nil)
        } else {
            self.getFeed()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return self.postArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MainFeedCell", forIndexPath: indexPath) as! MainFeedTableViewCell
        
        if let getPhoto = self.postArray[indexPath.section].photo {
            cell.cellImageView.image = getPhoto.image
        } else {
            cell.cellImageView.image = UIImage(named: "image")
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
        let post = self.postArray[section]
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.95)
        
        // Add a UILabel for the username here
        
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        if let avatarUser = post.user {
            let avImg = avatarUser.avatar
            imageView.image = getRoundImage(avImg)
        } else {
            imageView.image = UIImage(named: "image")
        }
        headerView.addSubview(imageView)
        
        let label = UILabel(frame: CGRect(x:50, y:10, width: self.view.frame.width - imageView.frame.width - 20, height: 30))
        
        label.font.fontWithSize(CGFloat(8))
        label.textAlignment = .Left
        
        label.text = post.user?.username
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
                        let post = self.postArray[indexPath.section]
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
    
    func getFeed() {
        
        DataService.dataService.PHOTO_REF.observeEventType(.ChildAdded, withBlock: { (response) in
//            self.postArray = []
            
            let post = Post()
            let photo = Photo()
            
            let imageData = NSData(base64EncodedString: (response.value["string"] as? String)!, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            let mainImg = UIImage(data: imageData!)
            photo.image = mainImg
            post.photo = photo
            
            let rootUrl = Firebase(url: "https://inpic-dev.firebaseio.com/posts/\((response.value.valueForKey("postID"))!)")
            let url = NSURL(string: rootUrl.description+".json")
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url!) { (data, response, error) -> Void in
                do {
                    
                    let getUser = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                    
                    let newRootUrl = Firebase(url: "https://inpic-dev.firebaseio.com/users/\((getUser["userID"])!)")
                    let newUrl = NSURL(string: newRootUrl.description+".json")
                    let newSession = NSURLSession.sharedSession()
                    let newTask = newSession.dataTaskWithURL(newUrl!) { (userData, userResponse, userError) -> Void in
                        do {
                            
                            let retrieveUser = try NSJSONSerialization.JSONObjectWithData(userData!, options: .AllowFragments) as! NSDictionary
                            
                            let username = retrieveUser["username"] as! String
                            let getUser = User(uid: self.loggedInUser.stringForKey("uid")!, username: username)
                            if let avatarExist = retrieveUser["avatar"] {
                                let avatarData = NSData(base64EncodedString: (avatarExist as? String)!, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                                let avatarImg = UIImage(data: avatarData!)
                                
                                getUser.avatar = avatarImg!
                            }
                            post.user = getUser
                            
                            self.postArray.insert(post, atIndex: 0)
                            
                            dispatch_async(dispatch_get_main_queue()){
                                self.tableView.reloadData()
                            }
                            
                            
                            
                        } catch let newError as NSError {
                            print(newError.localizedDescription)
                        }
                    }
                    newTask.resume()
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
            task.resume()
            
            //}
            
        })
        
        DataService.dataService.BASE_REF.keepSynced(true)
        
    }
}
