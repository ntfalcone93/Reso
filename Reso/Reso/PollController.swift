//
//  PollController.swift
//  Reso
//
//  Created by Patrick Pahl on 8/4/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import Foundation

// TODO: Move to new file when ready
/***********************************************/
import UIKit

class PollListViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloadTable), name: PollController.pollsChangedNotification, object: nil)
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PollController.sharedController.polls.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // TODO: return real cell for poll
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let poll = PollController.sharedController.polls[indexPath.row]
        print(poll) // TODO: Remove debug logging
        // cell.update(with: poll)
        return cell
    }
    
}
/***********************************************/

class PollController {
    
    static let sharedController = PollController()
    
    static let pollsChangedNotification = "pollAddedNotification"
    
    var polls = [Poll]()
    var publicPolls: [Poll] {
        return polls.filter { !$0.isPrivate }
    }
    var privatePolls: [Poll] {
        return polls.filter { $0.isPrivate }
    }
    
    func create(title: String, options: [Option], memberIds: [String], isPrivate: Bool, endDate: NSDate) {
        var newPoll = Poll(title: title, options: options, memberIds: memberIds, isPrivate: isPrivate, endDate: endDate)
        newPoll.save()
    }
    
    func delete(poll: Poll) {
        poll.delete()
    }
    
    /**
     Subscribes to all poll objects in Firebase. Sends an `NSNotification` named `PollController.pollsChangedNotification` when
     a poll is added, changed, or removed.
     
     Note: This only needs to be called once in the app—after the current user has authenticated, and you have the current user id.
     */
    func subscribeToAllPolls() {
        let query = FirebaseController.ref.child("polls").queryOrderedByChild("members").queryEqualToValue(UserController.shared.currentUserId)
        query.observeEventType(.ChildAdded, withBlock: { data in
            guard let dataDict = data.value as? [String: AnyObject],
                poll = Poll(dictionary: dataDict, identifier: data.key) else { return }
            self.polls.append(poll)
            NSNotificationCenter.defaultCenter().postNotificationName(PollController.pollsChangedNotification, object: data.key)
        })
        query.observeEventType(.ChildChanged, withBlock: { data in
            guard let dataDict = data.value as? [String: AnyObject],
                poll = Poll(dictionary: dataDict, identifier: data.key), index = self.polls.indexOf(poll) else { return }           ///Index?
            self.polls[index] = poll
            NSNotificationCenter.defaultCenter().postNotificationName(PollController.pollsChangedNotification, object: data.key)
            // Using data.key as object allows you to subscribe to this notification only for a specific identifier:
            // Example for detail page
//            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(update), name: PollController.pollsChangedNotification, object: currentPoll.identifier)
        })
        query.observeEventType(.ChildRemoved, withBlock: { data in
            guard let dataDict = data.value as? [String: AnyObject],
                poll = Poll(dictionary: dataDict, identifier: data.key), index = self.polls.indexOf(poll) else { return }
            self.polls.removeAtIndex(index)
            NSNotificationCenter.defaultCenter().postNotificationName(PollController.pollsChangedNotification, object: data.key)
        })
    }
    
    func vote(option: Option) {                                                                          ///ref poll identifier
    
    
    
    }
    
    
                                                                                                                ///fetch members(users) using poll ID
    func fetchUsersForPoll(poll: Poll, completion: (user: [User]) -> Void) {
   
//    FirebaseController.ref.child("polls").child(identifier).
    }
    
    
}

