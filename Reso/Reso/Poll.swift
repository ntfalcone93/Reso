//
//  Poll.swift
//  Reso
//
//  Created by Patrick Pahl on 8/2/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import Foundation

struct Poll: FirebaseType {
    
    private let kTitle = "title"
    private let kOptions = "options"
    private let kMembers = "members"
    private let kIsPrivate = "isPrivate"
    private let kCreationDate = "creationDate"
    private let kEndDate = "endDate"
    
    
    var title: String
    var options: [Option]
    var memberIds: [String]
    var isPrivate: Bool
    var creationDate: NSDate
    var endDate: NSDate
    var identifier: String?
    
    //    var hasVoted {
    //    }
    //
    //    var timeRemaining {
    //    }
    
    var endpoint: String {
        return "polls"
    }
    
    var dictionaryCopy: [String : AnyObject] {
        return [kTitle: title, kOptions: options.map{ $0.dictionaryCopy }, kMembers: memberIds.map{ [$0 : true] }, kIsPrivate: isPrivate, kCreationDate: creationDate.timeIntervalSince1970, kEndDate: endDate.timeIntervalSince1970]
    }
    
    init(title: String, options: [Option], memberIds: [String], isPrivate: Bool, endDate: NSDate) {
        
        self.title = title
        self.options = options
        self.memberIds = memberIds
        self.isPrivate = isPrivate
        self.creationDate = NSDate()
        self.endDate = endDate
    }
    
    
    init?(dictionary: [String : AnyObject], identifier: String) {
        guard let title = dictionary[kTitle] as? String,
            options = dictionary[kOptions] as? [String: [String: AnyObject]],
            membersDicts = dictionary[kMembers] as? [String: AnyObject],
            isPrivate = dictionary[kIsPrivate] as? Bool,
            creationDate = dictionary[kCreationDate] as? Double,
            endDate = dictionary[kEndDate] as? Double else {
                return nil
        }
        self.title = title
        self.options = options.flatMap{ Option(dictionary: $1, identifier: $0) }
        self.memberIds = Array(membersDicts.keys)
        self.isPrivate = isPrivate
        self.creationDate = NSDate(timeIntervalSince1970: creationDate)
        self.endDate = NSDate(timeIntervalSince1970: endDate)
    }
    
}


// MARK: - Equatable

extension Poll: Equatable { }

func ==(lhs: Poll, rhs: Poll) -> Bool {
    return lhs.identifier == rhs.identifier && lhs.title == rhs.title
}
