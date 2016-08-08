//
//  PollOptionsViewController.swift
//  Reso
//
//  Created by Sean Gilhuly on 8/3/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import UIKit

class PollOptionsViewController: UIViewController {
    
    
    var options = [Option]()
    
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
    
    @IBAction func buttonTapped(sender: UIButton) {
        switch sender.tag {
        case 0:
        //
        case 1:
        //
        case 2:
        //
        case 3:
        //
        default:
            break
        }
        performSegueWithIdentifier("toResultsSegue", sender: nil)
    }
    
    
    @IBAction func buttonTouchDown(sender: UIButton) {
        sender.layer.borderWidth = 2.0
        guard sender.backgroundColor != nil else { return }
        sender.layer.borderColor = sender.backgroundColor?.CGColor
        sender.backgroundColor = nil
    }
    
    @IBAction func buttonTouchCancelled(sender: UIButton) {
        sender.layer.borderWidth = 0.0
        guard let cgColor = sender.layer.borderColor else { return }
        sender.backgroundColor = UIColor(CGColor: cgColor)
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToOptions(segue: UIStoryboardSegue) { }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
}