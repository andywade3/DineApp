
//
//  ActivityProfileViewController.swift
//  Dine
//
//  Created by you wu on 3/14/16.
//  Copyright © 2016 YYZ. All rights reserved.
//

import UIKit
import MBProgressHUD

class ActivityProfileViewController: UITableViewController {
    let kHeaderHeight:CGFloat = 150.0
    var profileView = UIImageView()
    var activity: Activity!
    var groupMembers = [GroupMember]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //check if user joined activity, if true set chatButton enable = true, else set enable = false
        let tableHeaderView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kHeaderHeight))
        
        profileView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kHeaderHeight)
        profileView.clipsToBounds = true
        profileView.contentMode = .ScaleAspectFill
        if let url = activity.profileURL {
            profileView.setImageWithURL(url)
        }
        tableHeaderView.addSubview(profileView)
        self.tableView.tableHeaderView = tableHeaderView
        fetchGroupMembers()

    }

    func fetchGroupMembers() {
        if let activity = activity {
            print("Try fetchGroupMembers")
            activity.fetchGroupMember({ (groupMembers: [GroupMember]) in
                self.groupMembers = groupMembers
                self.tableView.reloadData()
                print("fetchGroupMembers success \(self.groupMembers.count)")
                }, failureHandler: { (error: NSError?) -> () in
                print(error?.localizedDescription)
            })
        }
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("profileCell") as! ActivityProfileCell
                
                cell.activity = self.activity
            if Activity.current_activity == nil {
                cell.checkButton.setImage(UIImage(named: "Checked"), forState: .Normal)
                cell.checkButton.addTarget(self, action: #selector(ActivityProfileViewController.checkButtonClicked(_:)), forControlEvents: UIControlEvents.TouchDown)
            } else if Activity.current_activity!.activityId == self.activity!.activityId {
                cell.checkButton.setImage(UIImage(named: "Cancel"), forState: .Normal)
                cell.checkButton.addTarget(self, action: #selector(ActivityProfileViewController.checkButtonClicked(_:)), forControlEvents: UIControlEvents.TouchDown)
            } else{
                Log.error("should not reach here")
                cell.checkButton.setImage(nil, forState: .Normal)
            }
            cell.checkButton.adjustsImageWhenHighlighted = false
            return cell
            
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("memberCell", forIndexPath: indexPath) as! ActivityMemberCell
            let member = groupMembers[indexPath.row - 1]
            cell.userId = member.userId
            cell.nameLabel.text = member.screenName
            if member.joined {
                cell.statusLabel.text = "Accepted"
            } else {
                cell.statusLabel.text = "Waiting for Acceptance"
            }
            return cell
        }
    }
    
   
    func checkButtonClicked (sender : UIButton!) {
        if Activity.current_activity == nil {
            sender.setImage(UIImage(named: "cancel"), forState: .Normal)
            sender.setImage(UIImage(named: "cancel"), forState: .Highlighted)
            Activity.current_activity = self.activity
            self.activity.joinActivity({
                NSNotificationCenter.defaultCenter().postNotificationName("userJoinedNotification", object: nil)
                }, failureHandler: { (error: NSError?) in
                    Log.error(error?.localizedDescription)
                    
            })

        }else {
            sender.setImage(UIImage(named: "checked"), forState: .Normal)
            sender.setImage(UIImage(named: "checked"), forState: .Highlighted)
            NSNotificationCenter.defaultCenter().postNotificationName("userExitedNotification", object: nil)
        }
        
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 115
        }
        return 45
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return 1 + groupMembers.count // 1 + number of members
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let yPos: CGFloat = -scrollView.contentOffset.y
        
        if (yPos > 0) {
            var imgRect: CGRect = profileView.frame
            imgRect.origin.y = scrollView.contentOffset.y
            imgRect.size.height = kHeaderHeight+yPos
            profileView.frame = imgRect
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toGroupChatSegue" {
            let vc = segue.destinationViewController as! ChatViewController
            if let groupChatId = activity?.groupChatId {
                vc.groupChatId = groupChatId

            }
        }
    }

}
