//
//  PollController.swift
//  Reso
//
//  Created by Patrick Pahl on 8/4/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import Foundation

enum PollType {
    case Public
    case Private
}

class PollController {
    
    static func create(title: String, options: [Option], memberIds: [String], isPrivate: Bool, endDate: NSDate) {
        var newPoll = Poll(title: title, options: options, memberIds: memberIds, isPrivate: isPrivate, endDate: endDate)
        newPoll.save()
    }
    
    func delete(poll: Poll) {
        poll.delete()
    }
    
    
    static func observePolls(pollType: PollType, completion: (polls: [Poll]) -> Void) {
        switch pollType {
        case .Private:
            // We need to observe the poll that belong to the current user
            let currentUserId = UserController.shared.currentUserId
            let ref = FirebaseController.ref.child("usersPolls").child(currentUserId)
            ref.observeEventType(.Value, withBlock: { (data) in
                guard let pollDict = data.value as? [String: AnyObject] else {
                    completion(polls: [])
                    return
                }
                let pollIds = Array(pollDict.keys)
                var polls = [Poll]()
                let group = dispatch_group_create()
                for pollId in pollIds {
                    dispatch_group_enter(group)
                    fetchPollWithIdentifier(pollId, completion: { (poll) in
                        if let poll = poll {
                            polls.append(poll)
                            dispatch_group_leave(group)
                        }
                    })
                }
                dispatch_group_notify(group, dispatch_get_main_queue(), {
                    completion(polls: polls)
                })
            })
        case .Public:
            // If its public then we will observe only the polls that are public
            let ref = FirebaseController.ref.child("polls").queryOrderedByChild("isPrivate").queryEqualToValue(false)
            ref.observeEventType(.Value, withBlock: { (data) in
                guard let pollDicts = data.value as? [String: [String: AnyObject]] else {
                    completion(polls: [])
                    return
                }
                let polls = pollDicts.flatMap { Poll(dictionary: $1, identifier: $0) }
                completion(polls: polls)
            })
        }
    }
    
    
    static func fetchPollWithIdentifier(identifier: String, completion: (poll: Poll?) -> Void) {
        let ref = FirebaseController.ref.child("polls").child(identifier)
        ref.observeSingleEventOfType(.Value, withBlock:  { (data) in
            guard let pollDict = data.value as? [String: AnyObject] else {
                completion(poll: nil)
                return
            }
            let poll = Poll(dictionary: pollDict, identifier: identifier)
            completion(poll: poll)
        })
    }
    
    
    static func vote(option: Option) {                                                                          ///ref poll identifier
    
    
    
    }
    
    
                                                                                                                ///fetch members(users) using poll ID
    func fetchUsersForPoll(poll: Poll, completion: (user: [User]) -> Void) {
   
//    FirebaseController.ref.child("polls").child(identifier).
    }
    
    
}

