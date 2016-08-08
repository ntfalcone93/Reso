//
//  PollController.swift
//  Reso
//
//  Created by Patrick Pahl on 8/4/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import Foundation
import FirebaseDatabase

enum PollType {
    case Public
    case Private
}

class PollController {
    
    private static var usersPollKey = "usersPolls"
    
    static var pollRef: FIRDatabaseReference {
        return FirebaseController.ref.child(Poll.key)
    }
    
    static var usersPollRef: FIRDatabaseReference {
        return FirebaseController.ref.child(usersPollKey)
    }
    
    static func create(title: String, options: [Option], memberIds: [String], isPrivate: Bool, endDate: NSDate) {
        var newPoll = Poll(title: title, options: options, memberIds: memberIds, isPrivate: isPrivate, endDate: endDate)
        newPoll.save()
        
        memberIds.forEach { (id) in
            savePollToUsersPolls(newPoll, userId: id)
        }
    }
    
    static func savePollToUsersPolls(poll: Poll, userId: String) {
        guard let pollId = poll.identifier else {
            return
        }
        usersPollRef.child(userId).child(pollId).setValue(true)
    }
    
    static func delete(poll: Poll) {
        guard let pollId = poll.identifier else {
            poll.delete()
            return
        }
        poll.memberIds.forEach { (id) in
            usersPollRef.child(id).child(pollId).removeValue()
        }
        poll.delete()
        
    }
    
    
    static func observePolls(pollType: PollType, completion: (polls: [Poll]) -> Void) {
        switch pollType {
        case .Private:
            // We need to observe the poll that belong to the current user
            let currentUserId = UserController.shared.currentUserId
            usersPollRef.child(currentUserId).observeEventType(.Value, withBlock: { (data) in
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
            let ref = FirebaseController.ref.child(Poll.key).queryOrderedByChild("isPrivate").queryEqualToValue(false).queryLimitedToLast(20)
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
        let ref = FirebaseController.ref.child(Poll.key).child(identifier)
        ref.observeSingleEventOfType(.Value, withBlock:  { (data) in
            guard let pollDict = data.value as? [String: AnyObject] else {
                completion(poll: nil)
                return
            }
            let poll = Poll(dictionary: pollDict, identifier: identifier)
            completion(poll: poll)
        })
    }
    
    static func vote(poll: Poll, option: Option) {
        guard let pollId = poll.identifier else {
            return
        }
        pollRef.child(pollId).child(Option.key).child(option.identifier).child(Option.voteKey).child(UserController.shared.currentUserId).setValue(true)
    }
    
    func fetchUsersForPoll(poll: Poll, completion: (user: [User]) -> Void) {
        var users = [User]()
        let group = dispatch_group_create()
        var count = 0
        poll.memberIds.forEach { (id) in
            dispatch_group_enter(group)
            UserController.fetchUserForIdentifier(id, completion: { (user) in
                if let user = user {
                    users.append(user)
                }
                dispatch_group_leave(group)
            })
        }
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            print(count)
            completion(user: users)
        }

    }
}

