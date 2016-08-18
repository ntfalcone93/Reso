//
//  MainMenuTableViewCell.swift
//  Reso
//
//  Created by Jonathan Rogers on 8/3/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import UIKit

// TODO:
// take off seconds unless it is continuously updating
// auto update minutes
// adjust the title and timer label so that it always fits


class PollTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var votingStatusImageView: UIImageView!
    
    @IBOutlet weak var pollNameLabel: UILabel!
    
    @IBOutlet weak var membersIconImageView: UIImageView!
    
    @IBOutlet weak var numberOfMembersLabel: UILabel!
    
    @IBOutlet weak var timeRemainingIcon: UIImageView!
    
    @IBOutlet weak var timerRemainingLabel: UILabel!
    
    func updateWithPoll(poll: Poll) {
        pollNameLabel.text = poll.title
        if poll.hasVoted == true {
            votingStatusImageView.image = UIImage(named: "newCheckMark")
        } else {
            votingStatusImageView.image = UIImage(named: "uncheckedBox")
        }
        if poll.isPrivate == false {
            membersIconImageView.hidden = true
            numberOfMembersLabel.hidden = true
        }
        numberOfMembersLabel.text = "\(poll.memberIds.count)"
//        timerRemainingLabel.text = "\(stringFromTimeInterval(poll.timeRemaining))"
        if timerRemainingLabel.text?.characters.first == "0" {
            timerRemainingLabel.textColor = UIColor.redColor()
        }
        
        // TODO: Replace with corresponding images
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.timerRemainingLabel.alpha = 0.0
            self.timeRemainingIcon.alpha = 0.0
            self.numberOfMembersLabel.alpha = 0.0
            self.membersIconImageView.alpha = 0.0
            self.votingStatusImageView.alpha = 0.0
            self.pollNameLabel.alpha = 0.0
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.timerRemainingLabel.alpha = 1.0
            self.timeRemainingIcon.alpha = 1.0
            self.numberOfMembersLabel.alpha = 1.0
            self.membersIconImageView.alpha = 1.0
            self.votingStatusImageView.alpha = 1.0
            self.pollNameLabel.alpha = 1.0
            
            }, completion: nil)
        
        
    }
    
    func stringFromTimeInterval(interval:NSTimeInterval) -> String {
        
        let ti = NSInteger(interval)
        _ = ti % 60
        let hours = (ti / 60 / 60)
        let minutes = (ti - (hours*60*60)) / 60
        
        if hours <= 0 && minutes <= 0 {
            return String(format: "-", minutes)
        } else if hours <= 0 && minutes >= 0 {
            return String(format: "%0.2d mins")
        } else {
            return String(format: "%0.2d hrs",hours)
        }
    }
    
}
