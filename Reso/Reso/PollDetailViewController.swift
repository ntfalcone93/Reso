//
//  PollDetailViewController.swift
//  Reso
//
//  Created by Sean Gilhuly on 8/3/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import UIKit

enum PollDetail {
    case Options
    case Results
}

class PollDetailViewController: UIViewController, UITextFieldDelegate, ChangeAlphaWhenButtonTapped {
    
    var comments: [Comment] = []
    var poll: Poll?
    var users = [User]()
    
    var pollDetail: PollDetail {
        guard let poll = poll else { return .Options }
        return poll.hasVoted == false ? .Options : .Results
    }
    
    var pollType: PollType = .Private
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var sendButton: UIButton!
    
    
    @IBOutlet weak var pollOptionsContainerView: UIView!
    @IBOutlet weak var pollResultsContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        
        setupKeyboardNotifications()
        
        hideKeyboardWhenTappedAround()
        
        self.pollOptionsContainerView.alpha = self.pollDetail == .Options ? 1 : 0
        self.pollResultsContainerView.alpha = self.pollDetail == .Options ? 0 : 1
        
        tableView.allowsSelection = false
        
        commentTextField.delegate = self
        
        self.navigationItem.title = "Poll Information"
        
        fetchComments()
        fetchUsers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        sendButton.enabled = false
        
    }
    
    // MARK: - IBActions
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        
        guard let currentUser = UserController.shared.currentUser else { return }
        
        if let commentText = commentTextField.text, let currentUserID = currentUser.identifier, poll = self.poll, pollID = poll.identifier {
            CommentController.create(commentText, senderId: currentUserID, pollId: pollID)
        } else {
            let alertController = UIAlertController(title: "Missing Information", message: "You did not type any text.", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            
            presentViewController(alertController, animated: true, completion: nil)
        }
        commentTextField.resignFirstResponder()
        commentTextField.text = ""
        sendButton.enabled = false
        
    }
    
    // MARK: - Functions
    
    func fetchComments() {
        guard let poll = poll else { return }
        CommentController.observeCommentsOnPoll(poll) { (comments) in
            self.comments = comments.sort { $0.timestamp.timeIntervalSince1970 < $1.timestamp.timeIntervalSince1970 }
            self.tableView.reloadData()
            if self.pollType == .Public {
                self.fetchCommentsSenders()
            }
        }
    }
    
    func changeAlpha() {
        UIView.animateWithDuration(0.5) {
            self.pollOptionsContainerView.alpha = self.pollDetail == .Options ? 0 : 1
            self.pollResultsContainerView.alpha = self.pollDetail == .Options ? 1 : 0
        }
    }
    
    func checkIfCurrentUserVoted() -> Bool {
        guard let poll = poll else { return false }
        for option in poll.options {
            if option.votes.contains(UserController.shared.currentUserId) {
                return true
            }
        }
        return false
    }
    
    // MARK: - Helper Function
    
    func fetchUsers() {
        if pollType == .Private {
            guard let poll = poll else { return }
            PollController.fetchUsersForPoll(poll) { (users) in
                self.users = users
                self.tableView.reloadData()
                self.fetchUsersPhotos(users)
            }
        }
    }
    
    func fetchUsersPhotos(users: [User]) {
        PollController.fetchUsersPhotos(users, completion: { (users) in
            self.users = users
            self.tableView.reloadData()
        })
    }
    
    func fetchCommentsSenders() {
        var senderIds = [String]()
        comments.forEach { (comment) in
            if senderIds.contains(comment.senderID) == false {
                senderIds.append(comment.senderID)
            }
        }
        guard comments.count > 0 else { return }
        let group = dispatch_group_create()
        senderIds.forEach { (senderId) in
            dispatch_group_enter(group)
            UserController.fetchUserForIdentifier(senderId, completion: { (user) in
                if let user = user {
                    self.users.append(user)
                }
                dispatch_group_leave(group)
            })
        }
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            self.tableView.reloadData()
            self.fetchUsersPhotos(self.users)
        }
        
    }
    
    func userForID(userID: String) -> User? {
        var userToReturn: User?
        users.forEach { (user) in
            if user.identifier == userID {
                userToReturn = user
            }
        }
        return userToReturn
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toOptionsSegue" {
            if let pollOptionsViewController = segue.destinationViewController as? PollOptionsViewController {
                pollOptionsViewController.poll = self.poll
                pollOptionsViewController.delegate = self
            }
        } else if segue.identifier == "toResultsSegue" {
            if let pollResultsViewController = segue.destinationViewController as? PollResultsViewController {
                pollResultsViewController.poll = poll
            }
        }
    }
}

extension PollDetailViewController {
    
    // MARK: - TextField Delegate(s)
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        commentTextField.autocapitalizationType = .Sentences
        commentTextField.autocorrectionType = .Yes
        
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if commentTextField.text?.characters.count > 0 {
            sendButton.enabled = true
        }
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        switch sendButton.enabled {
        case commentTextField.text?.characters.count > 0 :
            sendButton.enabled = true
        case commentTextField.text!.isEmpty:
            sendButton.enabled = false
        default:
            sendButton.enabled = false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        commentTextField.resignFirstResponder()
        return true
    }
}

extension PollDetailViewController {
    // MARK: - Keyboard translation & scroll
    
    func setupKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        guard let userInfo: [NSObject: AnyObject] = sender.userInfo,
            keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size,
            offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size else { return }
        if keyboardSize.height == offset.height && self.view.frame.origin.y == 0 {
            UIView.animateWithDuration(0.1, animations: {
                self.view.frame.origin.y -= keyboardSize.height
            })
        } else {
            UIView.animateWithDuration(0.1, animations: {
                self.view.frame.origin.y += (keyboardSize.height - offset.height)
            })
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        guard let userInfo: [NSObject: AnyObject] = sender.userInfo,
            keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size else { return }
        self.view.frame.origin.y += keyboardSize.height
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PollDetailViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension PollDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as? CommentsTableViewCell ?? CommentsTableViewCell()
        
        let comment = comments[indexPath.row]
        if let user = userForID(comment.senderID)  {
            cell.updateWithCommentAndUser(comment, user: user)
        } else {
            cell.updateWithComment(comment)
        }
        
        return cell
    }
}








