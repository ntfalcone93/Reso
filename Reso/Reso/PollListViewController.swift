//
//  MainMenuViewController.swift
//  Reso
//
//  Created by Jonathan Rogers on 8/3/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import UIKit

class PollListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pollSegmentController: UISegmentedControl!
    @IBOutlet weak var createNewPollButtonOutlet: UIBarButtonItem!
    
    
    var polls: [Poll] = []
    
    var selectedIndexPath: NSIndexPath!
    
    var completedPolls: [Poll] {
        return polls.filter { $0.isComplete }
    }
    
    var incompletePolls: [Poll] {
        return polls.filter { !$0.isComplete }
    }
    
    var pollSegment: PollType {
        switch pollSegmentController.selectedSegmentIndex {
        case 0:
            return .Private
        default:
            return .Public
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard UserController.shared.currentUser != nil else {
            performSegueWithIdentifier("toLogin", sender: self)
            return
        }
        setupLeftNavItem()
        //setupRightNavItem()
        setupSegmentedController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        guard UserController.shared.currentUser != nil else {
            return
        }
        observePolls()
    }
    
    func setupLeftNavItem() {
        let leftNavItem = UIButton()
        let usersImage = FirebaseController.storageRef.child("users/\(UserController.shared.currentUserId)/photoUrl")
        leftNavItem.setBackgroundImage(UserController.shared.currentUser?.photo, forState: .Normal)
        print(UserController.shared.currentUser?.photo)
        leftNavItem.layer.borderWidth = 1
        leftNavItem.layer.borderColor = UIColor.blackColor().CGColor
        leftNavItem.clipsToBounds = true
        leftNavItem.addTarget(self, action: #selector(PollListViewController.logoutAlert), forControlEvents: .TouchUpInside)
        leftNavItem.frame = CGRectMake(0, 0, 30, 30)
        leftNavItem.layer.cornerRadius = leftNavItem.frame.height / 2
        let barButton = UIBarButtonItem(customView: leftNavItem)
        self.navigationItem.leftBarButtonItem = barButton
        
    }
    
    //    func setupProfileImage() {
    //        let user: User?
    //        let _ = user?.photo
    //    }
    
    
    //    func setupRightNavItem() {
    //
    //        let rightNavButton = UIButton()
    //        rightNavButton.setTitle("+", forState: .Normal)
    //        rightNavButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
    //        rightNavButton.titleLabel!.font = UIFont(name: "AmericanTypewriter", size: 45)!
    //        rightNavButton.layer.shadowColor = UIColor.blackColor().CGColor
    //        rightNavButton.layer.shadowRadius = 0.5
    //        rightNavButton.layer.shadowOffset = CGSize(width: 0, height: 1.0)
    //        rightNavButton.layer.shadowOpacity = 2.5
    //        rightNavButton.clipsToBounds = true
    //        rightNavButton.addTarget(self, action: #selector(PollListViewController.logoutAlert), forControlEvents: .TouchUpInside)
    //        rightNavButton.frame = CGRectMake(0, 0, 30, 30)
    //        rightNavButton.layer.cornerRadius = rightNavButton.frame.height / 2
    //        let barButton = UIBarButtonItem(customView: rightNavButton)
    //        self.navigationItem.rightBarButtonItem = barButton
    //    }
    
    func setupSegmentedController() {
        pollSegmentController.layer.borderColor = MyColors.myLightGreenColor().CGColor
    }
    
    func logoutAlert() {
        
        let alert = UIAlertController(title: "", message: "Are you sure that you want to log out?", preferredStyle: .Alert)
        let logoutAction = UIAlertAction(title: "Logout", style: .Default) { (action) in
            //FirebaseController.base.unauth()
            //self.performSegueWithIdentifier("noUserLoggedIn", sender: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func observePolls() {
        PollController.observePolls(pollSegment) { (polls) in
            self.polls = polls.sort { $0.endDate.timeIntervalSince1970 < $1.endDate.timeIntervalSince1970 }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func segmentedContolButtonTapped(sender: AnyObject) {
        observePolls()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            if incompletePolls.count >= 1 {
                return "In progress"
            } else {
                return nil
            }
        }
        if section == 1 {
            if completedPolls.count >= 1 {
                return "Expired"
            } else {
                return nil
            }
        }
        return ""
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            print(incompletePolls.count)
            return incompletePolls.count
        } else {
            return completedPolls.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("pollCell") as! PollTableViewCell
        
        let poll = indexPath.section == 0 ? incompletePolls[indexPath.row] : completedPolls[indexPath.row]
        
        cell.updateWithPoll(poll)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndexPath = indexPath
        self.performSegueWithIdentifier("toPollDetail", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toPollDetail" {
            
            guard let indexPath = tableView.indexPathForSelectedRow,
                pollOptionsVC = segue.destinationViewController as? PollDetailViewController else {
                    return
            }
            if indexPath.section == 0 {
                pollOptionsVC.poll = incompletePolls[indexPath.row]
            } else {
                pollOptionsVC.poll = completedPolls[indexPath.row]
            }
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        
        let selectedPoll = self.polls[indexPath.row]
        
        let leaveAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "leave") { (UITableViewRowAction, NSIndexPath) -> Void in
            
            var membersInSelectedPoolArray = selectedPoll.memberIds
            if membersInSelectedPoolArray.contains(UserController.shared.currentUserId) {
            let indexPathOfCurrentUserID = membersInSelectedPoolArray.indexOf(UserController.shared.currentUserId)
            membersInSelectedPoolArray.removeAtIndex(indexPathOfCurrentUserID!)
            }
            self.tableView.reloadData()
        }
        
        return [leaveAction]
        
    }
}
