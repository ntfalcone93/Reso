//
//  AddMemberTableViewCell.swift
//  Reso
//
//  Created by Nathan on 8/9/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import UIKit

class AddMemberTableViewCell: UITableViewCell {
    
    weak var delegate: AddMemberCellDelegate?
    
    @IBOutlet weak var addMemberButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addMemberButton.layer.borderWidth = 2.0
        addMemberButton.layer.borderColor = UIColor.whiteColor().CGColor
        addMemberButton.layer.cornerRadius = 8
        
//        if PollType = PollType.Public {
//            addMemberButton.hidden = true
//        }
        
    }
    
    @IBAction func addMemberTapped(sender: AnyObject) {
        delegate?.addMembers()
    }
}

protocol AddMemberCellDelegate: class {
    func addMembers()
}
