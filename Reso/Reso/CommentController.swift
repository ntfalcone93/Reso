//
//  CommentController.swift
//  Reso
//
//  Created by Jonathan Rogers on 8/4/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import Foundation

class CommentController {
    
    static func create(text: String, senderId: String, pollId: String) {
        var comment = Comment(text: text, senderID: senderId, pollID: pollId)
        comment.save()
    }
    
    static func delete(comment: Comment) {
        comment.delete()
    }
    
    static func observeCommentsOnPoll(poll: Poll, completion: (comments: [Comment]) -> Void) {
        guard let pollId = poll.identifier else {
            completion(comments: [])
            return
        }
        
        FirebaseController.ref.child("comments").queryOrderedByChild("pollID").queryEqualToValue(pollId).observeEventType(.Value, withBlock: { (data) in
            
            print(data.value!)
            guard let commentDicts = data.value as? [String: [String: AnyObject]] else {
                completion(comments: [])
                return
            }
            let comments = commentDicts.flatMap { Comment(dictionary: $1, identifier: $0) }
            completion(comments: comments)
        })
    }
}