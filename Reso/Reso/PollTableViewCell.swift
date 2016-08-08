//
//  MainMenuTableViewCell.swift
//  Reso
//
//  Created by Jonathan Rogers on 8/3/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import UIKit

class PollTableViewCell: UITableViewCell {

    @IBOutlet weak var votingStatusImageView: UIImageView!
    
    @IBOutlet weak var pollNameLabel: UILabel!
    
    @IBOutlet weak var membersIconImageView: UIImageView!
    
    @IBOutlet weak var numberOfMembersLabel: UILabel!
    
    @IBOutlet weak var timerRemainingLabel: UILabel!
    
    func updateWithPoll(poll: Poll) {
        pollNameLabel.text = poll.title
        // TODO: Replace with corresponding images
        votingStatusImageView.image = poll.hasVoted ? UIImage(named: "complete") : UIImage(named: "incomplete")
        numberOfMembersLabel.text = "\(poll.memberIds.count)"
        timerRemainingLabel.text = "\(poll.timeRemaining)"
    }
}
