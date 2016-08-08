//
//  Option.swift
//  Reso
//
//  Created by Patrick Pahl on 8/2/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import Foundation


struct Option {
    
    static let key = "options"
    static let voteKey = "votes"
    private let kName = "name"
    private let kVotes = "votes"
    
    var name: String
    var votes: [String]
    var identifier: String

    
    var dictionaryCopy: [String : AnyObject]{
        return[kName: name, kVotes: votes.map { $0 }.toDic()]
    }
    
    init(name: String) {
        self.name = name
        self.votes = []
        self.identifier = FirebaseController.ref.childByAutoId().key
    }
    
    init?(dictionary: [String : AnyObject], identifier: String) {
        guard let name = dictionary[kName] as? String else {
                return nil
        }
        self.name = name
        if let voteDicts = dictionary[kVotes] as? [String: AnyObject] {
            self.votes = Array(voteDicts.keys)
        } else {
            self.votes = []
        }
        self.identifier = identifier
    }
}