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
    var photoUrl: String
    var identifier: String?
    
    var fullName: String {
        guard let lastInitial = lastName.characters.first else {
            return firstName
        }
        return firstName + String(lastInitial)
    }
    
    var endpoint: String {
        return "users"
    }
    
    var dictionaryCopy: [String : AnyObject] {
        return [kFirstName: firstName, kLastName: lastName, kPhotoUrl: photoUrl]
    }
    
    init(firstName: String, lastName: String, photoUrl: String, identifier: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.photoUrl = photoUrl
        self.identifier = identifier
    }
    
    
    init?(dictionary: [String: AnyObject], identifier: String) {
        guard let firstName = dictionary[kFirstName] as? String,
            let lastName = dictionary[kLastName] as? String,
            let photoUrl = dictionary[kPhotoUrl] as? String else {
                return nil
        }
        self.firstName = firstName
        self.lastName = lastName
        self.photoUrl = photoUrl
        self.identifier = identifier
    }
}