//
//  PollCreateViewController.swift
//  Reso
//
//  Created by Patrick Pahl on 8/3/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import UIKit

class PollCreateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        endDateTextField.inputView = dueDatePicker
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var dueDateValue: NSDate
    
    //MARK: Actions
    
    @IBAction func privatePublicValueChanged(sender: UISegmentedControl) {
    }
    
    @IBAction func DoneButtonTapped(sender: AnyObject) {
        
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func userTappedView(sender: AnyObject) {
        
        self.titleTextField.resignFirstResponder()
        self.endDateTextField.resignFirstResponder()
    }
    
    //MARK: Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet var dueDatePicker: UIDatePicker!
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
