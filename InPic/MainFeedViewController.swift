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

class MainFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ImagePickerDelegate {
    
    var postArray = [Post]()
    let imagePickerController = ImagePickerController()
    
    let user = User(username: "")
    let image = Photo()
    var returnedImage = UIImage()
    var returnedString = ""

    var didLoadImages: Bool!

    let loggedInUser = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataService.dataService.BASE_REF.keepSynced(true)
        self.tableView.rowHeight = self.view.frame.height / 3
        user.username = "jerlao"
//        image.img = UIImage(named: "image")
        self.didLoadImages = false

        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            DataService.dataService.PHOTO_REF.observeEventType(.ChildAdded, withBlock: { (data) in
                print(data.value.objectForKey("uid"))
                let imageData = NSData(base64EncodedString: data.value.objectForKey("string") as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                let backImage = UIImage(data: imageData!)
                let post = Post()
                post.image = backImage!
                if let time = data.value.objectForKey("timestamp") {
                    post.timestamp = String(time)
                }
                print(post.timestamp!)
                post.caption = "Test"
                self.postArray.append(post)
                self.didLoadImages = true
                print(self.returnedImage)
                self.returnedString = "Yo"
                dispatch_async(dispatch_get_main_queue()){
                    self.sortByTimestamp()
                    self.tableView.reloadData()
                    print("Reloaded table view")
                    print(self.postArray.count)
                }
                }, withCancelBlock: { (error) in
            })
    }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func sortByTimestamp()
    {
        self.postArray.sortInPlace({$0.timestamp > $1.timestamp})
    }

    override func viewDidAppear(animated: Bool) {
        if let _ = self.loggedInUser.stringForKey("user") {

        } else {
            self.performSegueWithIdentifier("goLogInSegue", sender: nil)
        }
        self.tableView.reloadData()
    }

    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
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
        
        // Configure the cell...
        if (didLoadImages == true)
        {

            cell.cellImageView.image = self.postArray[indexPath.section].image
        } else {

        }
//      cell.textLabel?.text = returnedImage

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

    @IBAction func unwindToMainFeed(sender: UIStoryboardSegue) {

    }

    func cancelButtonDidPress() {
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.95)
        
        // Add a UILabel for the username here
        let label = UILabel(frame: CGRect(x:0, y:0, width: self.view.frame.width, height: 30))
        label.font.fontWithSize(CGFloat(8))
        label.textAlignment = .Center
        label.text = self.postArray[section].caption
        headerView.addSubview(label)
        
        return headerView
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "detailSegue" {
            let destination = segue.destinationViewController as! DetailImageViewController
            let indexPath = self.tableView.indexPathForCell(sender as! MainFeedTableViewCell)
            destination.post = self.postArray[(indexPath?.section)!] as! Post
        } else if segue.identifier == "postImageSegue" {
            let destination = segue.destinationViewController as! PostImageViewController
            destination.postImage = sender as? UIImage
        } else {
            //
        }
    }
    
}
