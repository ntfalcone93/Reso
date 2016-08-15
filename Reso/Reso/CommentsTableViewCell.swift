//
//  CommentsTableViewCell.swift
//  Reso
//
//  Created by Sean Gilhuly on 8/3/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {


    // MARK: - IBOutlets
    @IBOutlet weak var userPhotoImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userCommentLabel: UILabel!
    
    override func awakeFromNib() {
        userNameLabel.text = ""
        userCommentLabel.text = ""
    }
    // MARK: - Function
    
    func updateWithComment(comment: Comment, user: User) {
        userPhotoImageView.image = user.photo
        userNameLabel.text = user.discreetName
        userCommentLabel.text = comment.text
    }
}
