//
//  OptionTableViewCell.swift
//  Reso
//
//  Created by Nathan on 8/9/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import UIKit

class OptionTableViewCell: UITableViewCell {

    @IBOutlet weak var optionImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!

    func setupCell(optionNumber: Int) {
        optionImageView.image = UIImage(named: "Option \(index)")
        textField.placeholder = "Option title"
    }
}
