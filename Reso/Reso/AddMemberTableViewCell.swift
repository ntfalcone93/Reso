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
    
    @IBAction func addMemberTapped(sender: AnyObject) {
        delegate?.addMembers()
    }
}

protocol AddMemberCellDelegate: class {
    func addMembers()
}
