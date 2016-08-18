//
//  MainMenuViewController.swift
//  Reso
//
//  Created by Jonathan Rogers on 8/3/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import UIKit

class PollListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var privatePolls: [Poll] = []
    var publicPolls: [Poll] = []
    var incompletePolls: [Poll] = [Poll(title: "what movie should we go to", options: [], members: ["parker","sean","patrick","nate"], isPrivate: false, endDate: NSDate(timeIntervalSinceNow: 24)), Poll(title: "which vacatio shoudld we go on?", options: [], members: ["parker","sean","patrick","nate", "josh", "justin", "alan"], isPrivate: true, endDate: NSDate(timeIntervalSinceNow: 900))]
    var completePolls: [Poll] = [Poll(title: "who is your favorite super hero?", options: [], members: ["parker","sean","patrick"], isPrivate: true, endDate: NSDate(timeIntervalSinceNow: 24)), Poll(title: "should I buy the Jordan's or the LeBrons?", options: [], members: ["parker","sean","patrick","nate", "josh", "justin", "alan", "mason", "Tyler", "Jordan", "jake"], isPrivate: false, endDate: NSDate(timeIntervalSinceNow: 400000))]
    var user: User?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var privatePublicSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< HEAD
        
        
=======
>>>>>>> develop
        
        PollController.observePolls(.Public) { (polls) in
            print(polls.count)
        }
    }
<<<<<<< HEAD
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedContolButtonTapped(sender: AnyObject) {
        if privatePublicSegmentedControl.selectedSegmentIndex == 0 {
            
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Complete"
        } else {
            return "Incomplete"
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            print(incompletePolls.count)
            return incompletePolls.count
        } else {
            print(completePolls.count)
            return completePolls.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("pollCell") as! PollTableViewCell
        
        let poll = completePolls[indexPath.row]
        
        cell.votingStatusImageView.image = UIImage(named: "complete")
        cell.pollNameLabel.text = poll.title
        cell.numberOfMembersLabel.text = "\(poll.members.count)"
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH-mm"
        cell.timerRemainingLabel.text = formatter.stringFromDate(poll.endDate)
        
        
        return cell
    }
    
=======
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publicPolls.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // TODO: return real cell for poll
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let poll = publicPolls[indexPath.row]
        print(poll) // TODO: Remove debug logging
        // cell.update(with: poll)
        return cell
    }
    

>>>>>>> develop
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
