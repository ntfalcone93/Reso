//
//  PollDetailViewController.swift
//  Reso
//
//  Created by Sean Gilhuly on 8/3/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import UIKit

class PollDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var optionsContainerView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }

    // MARK: - IBActions
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
    }
    
    
    // MARK: - Functions
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PollDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
