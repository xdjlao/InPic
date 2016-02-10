//
//  DetailImageViewController.swift
//  InPic
//
//  Created by Jerry on 2/4/16.
//  Copyright © 2016 Ethan Thomas. All rights reserved.
//

import UIKit

class DetailImageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var post:Post?
    var commentArray = [Comment]()
    let user = User(username: "jerlao")
    let image = Photo()
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.rowHeight = self.tableView.frame.height/5
        self.tableView.separatorColor = UIColor.clearColor()
//        image.img = UIImage(named: "image")

        detailImageView.image = post?.image

        for i in 1...20 {
            let comment = Comment()
            comment.text = "Comment \(i)"

            let date = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day, .Month, .Year], fromDate: date)

            comment.date = "\(components.month)/\(components.day)/\(components.year)"
            
            commentArray.append(comment)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailCommentCell") as! CommentTableViewCell
        let comment = self.commentArray[indexPath.row]
        cell.usernameLabel.text = self.user.username
        cell.dateLabel.text = comment.date
        cell.commentLabel.text = comment.text
//        if indexPath.row == 0 {
//            cell.frame = CGRectMake(<#T##x: CGFloat##CGFloat#>, <#T##y: CGFloat##CGFloat#>, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>)
//        }
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let dragPosition = self.tableView.contentOffset.y
        let imageHeight = self.detailImageView.frame.size.height
        let tableHeight = self.tableView.frame.size.height
        self.detailImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, imageHeight - dragPosition)
        self.tableView.frame = CGRectMake(0, self.detailImageView.frame.size.height, self.view.frame.size.width, tableHeight + dragPosition)
//        print(self.tableView.contentOffset.y)
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
