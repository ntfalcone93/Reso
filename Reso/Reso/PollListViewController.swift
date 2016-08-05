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
    var incompletePolls: [Poll] = []
    var completePolls: [Poll] = []

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var privatePublicSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PollController.observePolls(.Public) { (polls) in
            print(polls.count)
        }
    }
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
