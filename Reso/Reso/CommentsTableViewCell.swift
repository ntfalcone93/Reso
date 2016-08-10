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
    
    
    // MARK: - Function
    
    func updateWithComment(comment: Comment, user: User) {
        userNameLabel.text = "\(user.firstName) \(user.lastName)"
        userCommentLabel.text = comment.text
    }
    
    func updateCell(comment: Comment) {
        userCommentLabel.text = comment.text
    }
}
