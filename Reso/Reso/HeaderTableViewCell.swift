//
//  HeaderTableViewCell.swift
//  Reso
//
//  Created by Nathan on 8/9/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import UIKit

enum HeaderType {
    case Option
    case Member
}

class HeaderTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    weak var delegate: HeaderCellDelegate?
    
    var headerType: HeaderType? {
        didSet {
            headerLabel.text = headerType == .Option ? "Options:" : "Members:"
            addButton.hidden = headerType == .Member ? true : false
        }
    }
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        guard let HeaderType = headerType else {
            return
        }
        delegate?.addButtonTapped(HeaderType)
    }
}

protocol HeaderCellDelegate: class {
    func addButtonTapped(headerType: HeaderType)
}
