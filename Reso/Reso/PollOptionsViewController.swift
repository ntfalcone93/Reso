//
//  PollOptionsViewController.swift
//  Reso
//
//  Created by Sean Gilhuly on 8/3/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import UIKit

class PollOptionsViewController: UIViewController {
    
    // MARK: - IBOutlets

    // MARK: Buttons
    @IBOutlet weak var questionOneButton: UIButton!
    @IBOutlet weak var questionTwoButton: UIButton!
    @IBOutlet weak var questionThreeButton: UIButton!
    @IBOutlet weak var questionFourButton: UIButton!
    
    // MARK: Labels
    @IBOutlet weak var questionOneLabel: UILabel!
    @IBOutlet weak var questionTwoLabel: UILabel!
    @IBOutlet weak var questionThreeLabel: UILabel!
    @IBOutlet weak var questionFourLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    // MARK: - IBActions
    // MARK: Button Tapped

    @IBAction func questionOneButtonTapped(sender: AnyObject) {
    }
    
    @IBAction func questionTwoButtonTapped(sender: AnyObject) {
    }
    
    @IBAction func questionThreeButtonTapped(sender: AnyObject) {
    }
    
    @IBAction func questionFourButtonTapped(sender: AnyObject) {
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
