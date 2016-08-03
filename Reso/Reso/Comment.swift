//
//  Comment.swift
//  Reso
//
//  Created by Patrick Pahl on 8/2/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import Foundation


struct Comment: FirebaseType{
    
    private let kText = "text"
    private let kTimestamp = "timestamp"
    private let kSenderID = "senderID"
    private let kPollID = "pollID"
    
    var text: String
    var timestamp: NSDate
    var senderID: String
    var pollID: String
    var identifier: String?
    
    var endpoint: String{
        return "comments"
    }
    
    var dictionaryCopy: [String : AnyObject]{
        return [kText: text, kTimestamp: timestamp.timeIntervalSince1970, kSenderID: senderID, kPollID: pollID]
    }
    
    init(text: String, senderID: String, pollID: String){
        self.text = text
        self.timestamp = NSDate()
        self.senderID = senderID
        self.pollID = pollID
    }
    
    init?(dictionary: [String : AnyObject], identifier: String) {
        guard let text = dictionary[kText] as? String,
        timestamp = dictionary[kTimestamp] as? Double,
        senderID = dictionary[kSenderID] as? String,
            pollID = dictionary[kPollID] as? String else {
                return nil
        }
        self.text = text
        self.timestamp = NSDate(timeIntervalSince1970: timestamp)
        self.senderID = senderID
        self.pollID = pollID
    }
}