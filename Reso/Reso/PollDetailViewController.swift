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
    @IBOutlet weak var resultsContainerView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let background = UIImage(named: "ResoBackground")
//        self.view.backgroundColor = UIColor(patternImage: background!)
    
    }

    // MARK: - IBActions
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
    }
    
    
    // MARK: - Functions
    
    func showResults() {
        if sender.selectedSegmentIndex == 0 {
            UIView.animateWithDuration(0.5, animations: {
                self.optionsContainerView.alpha = 1
                self.resultsContainerView.alpha = 0
            })
        } else {
            UIView.animateWithDuration(0.5, animations: {
                self.optionsContainerView.alpha = 0
                self.resultsContainerView.alpha = 1
            })
        }
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
