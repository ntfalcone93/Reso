//
//  User.swift
//  Reso
//
//  Created by Patrick Pahl on 8/2/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import Foundation
import UIKit

struct User: FirebaseType {
    
    private let kFirstName = "firstName"
    private let kLastName = "lastName"
    private let kFullName = "fullName"
    private let kPhotoUrl = "photo"
    
    var firstName: String
    var lastName: String
    var fullName: String
    var photoUrl: String
    var identifier: String?
    
    var endpoint: String {
        return "users"
    }
    
    var dictionaryCopy: [String : AnyObject] {
        return [kFirstName: firstName, kLastName: lastName, kFullName: fullName, kPhotoUrl: photoUrl]
    }
    
    init(firstName: String, lastName: String, fullName: String, photoUrl: String, identifier: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = fullName
        self.photoUrl = photoUrl
        self.identifier = identifier
    }
    
    
    init?(dictionary: [String: AnyObject], identifier: String) {
        guard let firstName = dictionary[kFirstName] as? String,
            let lastName = dictionary[kLastName] as? String,
            let fullName = dictionary[kFullName] as? String,
            let photoUrl = dictionary[kPhotoUrl] as? String else {
                return nil
        }
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = fullName
        self.photoUrl = photoUrl
        self.identifier = identifier
    }
}