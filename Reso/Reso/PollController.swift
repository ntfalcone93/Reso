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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(reloadTable), name: PollController.pollAddedNotification, object: nil)
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
    
    static let pollAddedNotification = "pollAddedNotification"
    
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
    
    func fetchAllPolls() {
        FirebaseController.ref.child("usersPolls").child(UserController.shared.currentUserId).observeEventType(.ChildAdded, withBlock: { data in
            guard let pollIdDictionaries = data.value as? [String: AnyObject], pollId = pollIdDictionaries.first?.0 else { return }
            self.fetchPoll(with: pollId) { poll in
                guard let poll = poll else { return }
                self.polls.append(poll)
                NSNotificationCenter.defaultCenter().postNotificationName(PollController.pollAddedNotification, object: nil)
            }
        })
    }
    
    func fetchPoll(with identifier: String, completion: (poll: Poll?) -> Void) {
        FirebaseController.ref.child("polls").child(identifier).observeSingleEventOfType(.Value, withBlock: { data in
            guard let dataDict = data.value as? [String: AnyObject],
                poll = Poll(dictionary: dataDict, identifier: data.key) else { completion(poll: nil); return }
            completion(poll: poll)
        })
    }
    
    func vote(option: Option) {                                                                          ///ref poll identifier
    
    
    
    }
    
    
                                                                                                                ///fetch members(users) using poll ID
    func fetchUsersForPoll(poll: Poll, completion: (user: [User]) -> Void) {
   
//    FirebaseController.ref.child("polls").child(identifier).
    }
    
    
}

