//
//  MainMenuViewController.swift
//  Reso
//
//  Created by Jonathan Rogers on 8/3/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import UIKit

class PollListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var polls: [Poll] = []
    
    var completedPolls: [Poll] {
        return polls.filter { $0.isComplete }
    }
    
    var incompletePolls: [Poll] {
        return polls.filter { !$0.isComplete }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pollSegmentController: UISegmentedControl!
    
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
        
        // TESTING: Works great
        //        let option1 = Option(name: "Helping students")
        //        let option2 = Option(name: "Patrick's computer")
        //        let option3 = Option(name: "Helping students beyond his paid time")
        //        let option4 = Option(name: "Losing in ping pong")
        //
        //        let timeInterval = NSTimeInterval(floatLiteral: 1231231233.123)
        //        PollController.create("How to annoy Nathan", options: [option1, option2, option3, option4], memberIds: [UserController.shared.currentUserId], isPrivate: true, endDate: NSDate(timeIntervalSinceNow: timeInterval))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        guard UserController.shared.currentUser != nil else {
            return
        }
        observePolls()
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
