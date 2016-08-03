//
//  Option.swift
//  Reso
//
//  Created by Patrick Pahl on 8/2/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import Foundation


struct Option: FirebaseType {
    
    private let kName = "name"
    private let kVotes = "votes"
    private let kPollId = "pollId"
    
    var name: String
    var votes: [String]
    var pollId: String
    var identifier: String?
    
    var endpoint: String {
        return "polls/\(pollId)/options"
    }
    
    var dictionaryCopy: [String : AnyObject]{
        return[kName: name, kVotes: votes.map { [$0 : true] }, kPollId: pollId]
    }
    
    init(name: String, pollId: String) {
        self.name = name
        self.votes = []
        self.pollId = pollId
    }
    
    init?(dictionary: [String : AnyObject], identifier: String) {
        guard let name = dictionary[kName] as? String,
            voteDict = dictionary[kVotes] as? [String: AnyObject],
            pollId = dictionary[kPollId] as? String else {
                return nil
        }
        self.name = name
        self.votes = Array(voteDict.keys)
        self.pollId = pollId
    }
}