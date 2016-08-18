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
        
        tableView.estimatedRowHeight = 63
        tableView.rowHeight = UITableViewAutomaticDimension
        
        guard UserController.shared.currentUser != nil else {
            performSegueWithIdentifier("toLogin", sender: self)
            return
        }
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        imageView.contentMode = .ScaleAspectFit
        imageView.image = UIImage(named: "RESO")
        navigationItem.titleView = imageView
        setupSegmentedController()
        setupLeftNavItem()
        setupRightNavItem()
        
        
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
        if let user = UserController.shared.currentUser {
            UserController.fetchUsersPhoto(user, completion: { (user) in
                leftNavItem.setImage(user.photo, forState: .Normal)
                leftNavItem.layer.cornerRadius = leftNavItem.frame.height / 2
                leftNavItem.layer.masksToBounds = true
                leftNavItem.layer.borderColor = UIColor.blackColor().CGColor
                leftNavItem.layer.borderWidth = 1.0
            })
        } else {
            leftNavItem.setImage(UIImage(named: "settingsIcon"), forState: .Normal)
        }
        leftNavItem.clipsToBounds = true
        leftNavItem.addTarget(self, action: #selector(PollListViewController.logoutAlert), forControlEvents: .TouchUpInside)
        leftNavItem.frame = CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem(customView: leftNavItem)
        self.navigationItem.leftBarButtonItem = barButton
        
    }
    
    func setupRightNavItem() {
        let rightNavButton = UIButton()
        rightNavButton.addTarget(self, action: #selector(PollListViewController.RightNavButtonSegue), forControlEvents: UIControlEvents.TouchUpInside)
        rightNavButton.setImage(UIImage(named: "addButton"), forState: .Normal)
        rightNavButton.layer.shadowColor = UIColor.blackColor().CGColor
        rightNavButton.layer.shadowRadius = 0.5
        rightNavButton.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        rightNavButton.layer.shadowOpacity = 2.5
        rightNavButton.clipsToBounds = true
        rightNavButton.frame = CGRectMake(0, 0, 28, 28)
        let barButton = UIBarButtonItem(customView: rightNavButton)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func RightNavButtonSegue() {
        performSegueWithIdentifier("toCreatePoll", sender: self)
    }
    
    func setupSegmentedController() {
        pollSegmentController.layer.borderColor = MyColors.myLightGreenColor().CGColor
    }
    
    func logoutAlert() {
        
        let alert = UIAlertController(title: "", message: "Are you sure that you want to log out?", preferredStyle: .Alert)
        let logoutAction = UIAlertAction(title: "Logout", style: .Default) { (action) in
            UserController.logoutUser()
            self.performSegueWithIdentifier("toLogin", sender: self)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(logoutAction)
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
            pollOptionsVC.pollType = pollSegment
            if indexPath.section == 0 {
                pollOptionsVC.poll = incompletePolls[indexPath.row]
            } else {
                pollOptionsVC.poll = completedPolls[indexPath.row]
            }
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // If pollSegment is private then the user can edit
        return pollSegment == .Private
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        
        let selectedPoll = self.polls[indexPath.row]
        
        let leaveAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "leave") { (UITableViewRowAction, NSIndexPath) -> Void in
            PollController.leavePoll(selectedPoll, completion: { 
                self.tableView.reloadData()
            })
        }
        
        return [leaveAction]
        
    }
}
