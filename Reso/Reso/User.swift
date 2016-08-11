//
//  User.swift
//  Reso
//
//  Created by Patrick Pahl on 8/2/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import UIKit

struct User: FirebaseType {
    
    static let userKey = "users"
    private let kFirstName = "firstName"
    private let kLastName = "lastName"
    private let kFullName = "fullName"
    private let kPhotoUrl = "photo"
    
    var firstName: String
    var lastName: String
    var photoUrl: String?
    var photo: UIImage?
    var identifier: String?
    
    var discreetName: String {
        guard let lastInitial = lastName.characters.first else {
            return firstName
        }
        return firstName + " " + String(lastInitial)
    }
    
    var fullName: String {
        return firstName + " " + lastName
    }
    
    var endpoint: String {
        return User.userKey
    }
    
    var dictionaryCopy: [String : AnyObject] {
        return [kFirstName: firstName, kLastName: lastName]
    }
    
    init(firstName: String, lastName: String, identifier: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.photoUrl = nil
        self.identifier = identifier
    }
    
    
    init?(dictionary: [String: AnyObject], identifier: String) {
        guard let firstName = dictionary[kFirstName] as? String,
            let lastName = dictionary[kLastName] as? String else {
                return nil
        }
        self.firstName = firstName
        self.lastName = lastName
        self.photoUrl = dictionary[kPhotoUrl] as? String ?? nil
        self.identifier = identifier
    }
}