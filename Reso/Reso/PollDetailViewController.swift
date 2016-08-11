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
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var pollOptionsContainerView: UIView!
    @IBOutlet weak var pollResultsContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardNotifications()
        
        hideKeyboardWhenTappedAround()
        
        self.pollOptionsContainerView.alpha = self.pollDetail == .Options ? 1 : 0
        self.pollResultsContainerView.alpha = self.pollDetail == .Options ? 0 : 1
        
    }
    
    // MARK: - IBActions
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        guard let currentUser = UserController.shared.currentUser else { return }
        
        if let commentText = commentTextField.text, let currentUserID = currentUser.identifier, poll = self.poll, pollID = poll.identifier {
            CommentController.create(commentText, senderId: currentUserID, pollId: pollID)
            updateComments(poll)
        } else {
            let alertController = UIAlertController(title: "Missing Information", message: "You did not type any text.", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Functions
    
    func changeAlpha() {
        UIView.animateWithDuration(0.5) { 
            self.pollOptionsContainerView.alpha = self.pollDetail == .Options ? 0 : 1
            self.pollResultsContainerView.alpha = self.pollDetail == .Options ? 1 : 0
        }
    }
    
    func updateComments(pollID: Poll) {
        CommentController.observeCommentsOnPoll(pollID, completion: { (comments) in
            self.comments = comments
            self.tableView.reloadData()
        })
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        commentTextField.resignFirstResponder()
        return true
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
        self.view.frame.origin.y  += keyboardSize.height
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
        
        //        let user = User
        cell.updateCell(comment)
        
        return cell
    }
}