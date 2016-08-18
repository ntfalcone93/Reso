//
//  PollOptionsViewController.swift
//  Reso
//
//  Created by Sean Gilhuly on 8/3/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//


// Change button size
// Chagne percentage color to black
// get rid of results on bottom right

import UIKit

class PollOptionsViewController: UIViewController {
    
    var poll: Poll?
    
    var options: [Option] {
        guard let poll = poll else {
            return []
        }
        return poll.options.sort { $0.identifier < $1.identifier }
    }
    
    weak var delegate: ChangeAlphaWhenButtonTapped?
    
    // MARK: - IBOutlets
    // MARK: - Question
    @IBOutlet weak var questionLabel: UILabel!
    
    // MARK: Buttons
    @IBOutlet weak var questionOneButton: UIButton!
    @IBOutlet weak var questionTwoButton: UIButton!
    @IBOutlet weak var questionThreeButton: UIButton!
    @IBOutlet weak var questionFourButton: UIButton!
    @IBOutlet var buttonCollection: [UIButton]!
    
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
        
        buttonCollection.forEach { (button) in
            button.layer.cornerRadius = button.frame.height / 2
        }
        guard let poll = poll else { return }
        questionLabel.text = "\(poll.title)?"
        
        if options.count == 2 {
            
            questionOneLabel.text = options[0].name
            questionTwoLabel.text = options[1].name
            
            questionThreeButton.hidden = true
            questionThreeLabel.hidden = true
            questionFourButton.hidden = true
            questionFourLabel.hidden = true
            
        } else if options.count == 3 {
            
            questionOneLabel.text = options[0].name
            questionTwoLabel.text = options[1].name
            questionThreeLabel.text = options[2].name
            
            questionFourButton.hidden = true
            questionFourLabel.hidden = true
            
        } else if options.count == 4 {
            
            questionOneLabel.text = options[0].name
            questionTwoLabel.text = options[1].name
            questionThreeLabel.text = options[2].name
            questionFourLabel.text = options[3].name
            
        } else {
            return
        }
        

    }
    
    // MARK: - IBActions
    // MARK: Button Tapped
    
    @IBAction func buttonTapped(sender: UIButton) {
        guard var poll = poll else { return }
        poll.options.sortInPlace { $0.identifier < $1.identifier }
        switch sender.tag {
        case 0:
            guard options.count >= 1 else {
                return
            }
            let option = options[0]
            PollController.vote(poll, option: option)
        case 1:
            guard options.count >= 2 else {
                return
            }
            let option = options[1]
            PollController.vote(poll, option: option)
        case 2:
            guard options.count >= 3 else {
                return
            }
            let option = options[2]
            PollController.vote(poll, option: option)
        case 3:
            guard options.count >= 4 else {
                return
            }
            let option = options[3]
            PollController.vote(poll, option: option)
        default:
            break
        }
        delegate?.changeAlpha()
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
}

protocol ChangeAlphaWhenButtonTapped: class {
    func changeAlpha()
}