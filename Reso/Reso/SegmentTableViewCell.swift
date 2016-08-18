//
//  SegmentTableViewCell.swift
//  Reso
//
//  Created by Nathan on 8/9/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import UIKit

class SegmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    weak var delegate: SegmentCellDelegate?
    
    var pollSegment: PollType {
        return segmentedControl.selectedSegmentIndex == 0 ? .Private : .Public
    }
    
    @IBAction func segmentChanged(sender: AnyObject) {
        delegate?.segmentChanged(pollSegment)
    }
}

protocol SegmentCellDelegate: class {
    func segmentChanged(pollType: PollType)
}