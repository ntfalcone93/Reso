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
//    var incompletePolls: [Poll] = [Poll(title: "what movie should we go to", options: [], members: ["parker","sean","patrick","nate"], isPrivate: false, endDate: NSDate(timeIntervalSinceNow: 24)), Poll(title: "which vacatio shoudld we go on?", options: [], members: ["parker","sean","patrick","nate", "josh", "justin", "alan"], isPrivate: true, endDate: NSDate(timeIntervalSinceNow: 900))]
//    var completePolls: [Poll] = [Poll(title: "who is your favorite super hero?", options: [], members: ["parker","sean","patrick"], isPrivate: true, endDate: NSDate(timeIntervalSinceNow: 24)), Poll(title: "should I buy the Jordan's or the LeBrons?", options: [], members: ["parker","sean","patrick","nate", "josh", "justin", "alan", "mason", "Tyler", "Jordan", "jake"], isPrivate: false, endDate: NSDate(timeIntervalSinceNow: 400000))]
    var user: User?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var privatePublicSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
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
            return 0
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("pollCell") as! PollTableViewCell
        
        
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
