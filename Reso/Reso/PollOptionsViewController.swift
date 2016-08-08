//
//  PollOptionsViewController.swift
//  Reso
//
//  Created by Sean Gilhuly on 8/3/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import UIKit

class PollOptionsViewController: UIViewController {
    
    var poll: Poll?
   
    var options: [Option] {
        guard let poll = poll else {
            return []
        }
        return poll.options
    }
    
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
        
        setupButtonsWithOptions()

        
    }
    
    func setupButtonsWithOptions() {
        if options.count == 2 {
            
            questionOneLabel.text = "\(options[0].name)"
            questionTwoLabel.text = "\(options[1].name)"

            questionThreeButton.hidden = true
            questionThreeLabel.hidden = true
            questionFourButton.hidden = true
            questionFourLabel.hidden = true
            
        } else if options.count == 3 {
            
            questionOneLabel.text = "\(options[0].name)"
            questionTwoLabel.text = "\(options[1].name)"
            questionThreeLabel.text = "\(options[2].name)"
        
            questionFourButton.hidden = true
            questionFourLabel.hidden = true
        
        } else if options.count == 4 {
            
            questionOneLabel.text = "\(options[0].name)"
            questionTwoLabel.text = "\(options[1].name)"
            questionThreeLabel.text = "\(options[2].name)"
            questionFourLabel.text = "\(options[3].name)"
            
        } else {
            return
        }
    }
    
    // MARK: - IBActions
    // MARK: Button Tapped
    
    @IBAction func buttonTapped(sender: UIButton) {
        switch sender.tag {
            
        
        case 0:
            guard options.count >= 1 else {
                return
            }
            print("Button 1 pressed 👍")

            
        case 1:
            guard options.count >= 2 else {
                return
            }
            print("Button 2 pressed 👍")
            
        case 2:
            guard options.count >= 3 else {
                return
            }
            print("Button 3 pressed 👍")
            
        case 3:
            guard options.count >= 4 else {
                return
            }
            print("Button 4 pressed 👍")
            
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