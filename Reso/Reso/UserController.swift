//
//  UserController.swift
//  MyPets
//
//  Created by Nathan on 6/8/16.
//  Copyright © 2016 Falcone Development. All rights reserved.
//

import Foundation
import Firebase

class UserController {
    
    static let currentUserKey = "currentUser"
    static let currentUserIdKey = "currentUserIdentifier"
    
    static let shared = UserController()
    
    static var userRef: FIRDatabaseReference {
        return FirebaseController.ref.child(User.userKey)
    }
    
    var currentUser = UserController.loadFromDefaults()
    
    var currentUserId: String {
        guard let currentUser = currentUser, currentUserId = currentUser.identifier else {
            return ""
        }
        return currentUserId
    }
    
    static func createUser(firstName: String, lastName: String, image: UIImage, email: String, password: String, completion: (user: User?) -> Void) {
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
            if let error = error {
                print("There was error while creating user: \(error.localizedDescription)")
                completion(user: nil)
            } else if let firebaseUser = user {
                var user = User(firstName: firstName, lastName: lastName, identifier: firebaseUser.uid)
                user.save()
                saveUsersPhoto(image, user: user, completion: { (user) in
                    UserController.shared.currentUser = user
                    UserController.saveUserInDefaults(user)
                    completion(user: user)
                })
            } else {
                completion(user: nil)
            }
        })
    }
    
    static func authUser(email: String, password: String, completion: (user: User?) -> Void) {
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (firebaseUser, error) in
            if let error = error {
                print("Wasn't able log user in: \(error.localizedDescription)")
                completion(user: nil)
            } else if let firebaseUser = firebaseUser {
                UserController.fetchUserForIdentifier(firebaseUser.uid, completion: { (user) in
                    guard let user = user else {
                        completion(user: nil)
                        return
                    }
                    UserController.shared.currentUser = user
                    UserController.saveUserInDefaults(user)
                    completion(user: user)
                })
            } else {
                completion(user: nil)
            }
        })
    }
    
    static func logoutUser() {
        do {
            try FIRAuth.auth()?.signOut()
            shared.currentUser = nil
            deleteUserFromDefaults()
        } catch {
            print("There was an error while signing out user. Error: \(error)")
        }
    }
    
    static func fetchUserForIdentifier(identifier: String, completion: (user: User?) -> Void) {
        FirebaseController.ref.child("users").child(identifier).observeSingleEventOfType(.Value, withBlock: { data in
            guard let dataDict = data.value as? [String: AnyObject],
                user = User(dictionary: dataDict, identifier: data.key) else {
                    completion(user: nil)
                    return
            }
            completion(user: user)
        })
    }
    
    static func fetchAllUsers(completion: (users: [User]) -> Void) {
        userRef.observeSingleEventOfType(.Value, withBlock: { (data) in
            guard let userDicts = data.value as? [String: [String: AnyObject]] else {
                completion(users: [])
                return
            }
            let users = userDicts.flatMap { User(dictionary: $1, identifier: $0) }
            completion(users: users)
        })
    }
    
    static func fetchUsersPhoto(user: User, completion: (user: User) -> Void) {
        guard let photoURLString = user.photoUrl, photoURL = NSURL(string: photoURLString) else {
            completion(user: user)
            return
        }
        ImageController.imageForURL(photoURL) { (image) in
            var user = user
            user.photo = image
            completion(user: user)
        }
    }
    
    
    private static func saveUserInDefaults(user: User) {
        NSUserDefaults.standardUserDefaults().setObject(user.dictionaryCopy, forKey: UserController.currentUserKey)
        NSUserDefaults.standardUserDefaults().setObject(user.identifier!, forKey: currentUserIdKey)
    }
    
    private static func loadFromDefaults() -> User? {
        let defaults = NSUserDefaults.standardUserDefaults()
        guard let userDict = defaults.objectForKey(currentUserKey) as? [String: AnyObject], userId = defaults.objectForKey(currentUserIdKey) as? String, user = User(dictionary: userDict, identifier: userId) else {
            return nil
        }
        return user
    }
    
    private static func deleteUserFromDefaults() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(currentUserKey)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(currentUserIdKey)
    }
    
    private static func saveUsersPhoto(photo: UIImage, user: User, completion: (user: User) -> Void) {
        guard let photoData = UIImageJPEGRepresentation(photo, 0.8) else { return }
        let newKey = FirebaseController.ref.childByAutoId().key
        FirebaseController.storageRef.child(User.userKey).child(newKey).putData(photoData, metadata: nil) { (metadata, error) in
            guard error == nil else {
                print("Error: \(error?.localizedDescription)")
                completion(user: user)
                return
            }
            guard let metadata = metadata,
                downloadUrl = metadata.downloadURL(),
                userId = user.identifier else { return }
            userRef.child(userId).child("photoUrl").setValue(downloadUrl.absoluteString)
            var userWithPhotoUrl = user
            userWithPhotoUrl.photoUrl = downloadUrl.absoluteString
            saveUserInDefaults(userWithPhotoUrl)
            completion(user: userWithPhotoUrl)
        }
    }
}