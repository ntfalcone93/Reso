//
//  MainMenuViewController.swift
//  Reso
//
//  Created by Jonathan Rogers on 8/3/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import UIKit

class PollListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pollSegmentController: UISegmentedControl!
    
    
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
       // setupLeftNavItem()
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
        let rightNavButton = UIButton()
        rightNavButton.setImage(UIImage(named: "defaultProfileImage"), forState: UIControlState.Normal)
        rightNavButton.layer.borderWidth = 1
        rightNavButton.layer.borderColor = UIColor.blackColor().CGColor
        rightNavButton.clipsToBounds = true
        rightNavButton.addTarget(self, action: #selector(PollListViewController.logoutAlert), forControlEvents: .TouchUpInside)
        rightNavButton.frame = CGRectMake(0, 0, 30, 30)
        rightNavButton.layer.cornerRadius = rightNavButton.frame.height / 2
        let barButton = UIBarButtonItem(customView: rightNavButton)
        self.navigationItem.leftBarButtonItem = barButton
        
    }
    
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
            return "Incomplete"
        } else {
            return "Complete"
        }
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
            if indexPath.section == 0 {
                pollOptionsVC.poll = incompletePolls[indexPath.row]
            } else {
                pollOptionsVC.poll = completedPolls[indexPath.row]
            }
        }
    }
}
