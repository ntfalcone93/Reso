//
//  PollDetailViewController.swift
//  Reso
//
//  Created by Sean Gilhuly on 8/3/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import UIKit

class PollDetailViewController: UIViewController, UITextFieldDelegate {
    
    var comments: [Comment] = []
    var poll: Poll?
    var users = [User]()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var optionsContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardNotifications()
        
        hideKeyboardWhenTappedAround()

        mockData()
        
        if let poll = poll {
            fetchUsersForPoll(poll)
        }
        
        
    }
    
    // MARK: - IBActions
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        let user = User(firstName: "Frank", lastName: "Billbong", identifier: "456A-78SR-TWV7-U23O")
        
        if let commentText = commentTextField.text, let currentUserID = user.identifier, poll = self.poll, pollID = poll.identifier {
            CommentController.create(commentText, senderId: currentUserID, pollId: pollID)
            updateComments(poll)
        } else {
             let alertController = UIAlertController(title: "Missing Information", message: "You did not type any text.", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func updateComments(pollID: Poll) {
        CommentController.observeCommentsOnPoll(pollID, completion: { (comments) in
            self.comments = comments
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Functions
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        commentTextField.resignFirstResponder()
        commentTextField.text = ""
        return true
    }
    
    func mockData() {
        let option = Option(name: "True")
        let option1 = Option(name: "False")
        self.poll = Poll(title: "Star Wars or Star TreK?", options: [option, option1], memberIds: ["turkeydumpling567", "googlehacks7823"], isPrivate: true, endDate: NSDate().dateByAddingTimeInterval(1500))
        self.poll?.identifier = "turkeyJones007"
    }
    
    
    // MARK: - Helper functions

    func fetchUsersForPoll(poll: Poll) {
        
    }
    
    // MARK: - Navigation 
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "optionsSegue" {
            if let pollOptionsVC = segue.destinationViewController as? PollOptionsViewController {
                pollOptionsVC.poll = poll
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
        let user = User(firstName: "Justin", lastName: "Smith", identifier: "resdtsd1123")
        cell.updateWithComment(comment, user: user)
        
        return cell
    }
}
