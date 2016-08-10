//
//  PollCreateDetailTableViewController.swift
//  Reso
//
//  Created by Patrick Pahl on 8/9/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

enum MemberType {
    case Searched
    case Added
}

class PollCreateDetailTableViewController: UITableViewController, UISearchBarDelegate {
    
    //TO DO
    //Segmented controller, Search and Friends Added, friends added: search bar = .hidden
    //fetch all users, exclude current user
    //Search names- filter, use lowercase  string.lowercase... remove current user from search
    //swipe to delete on friend list
    //func didSelectRow - get user indexpath[row], append user to array
    //*Detach listeners
    //*dispatch group create needed??
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var memberSegmentController: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var memberType: MemberType {
        switch memberSegmentController.selectedSegmentIndex {
        case 0:
            return .Searched
        default:
            return .Added
        }
    }
    
    var allUsers = [User]()
    var filteredUsers = [User]()
    var selectedMembers = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "ResoBackground"))
        
        fetchAllUsers()
    }
    
    
    func fetchAllUsers(){
        UserController.fetchAllUsers { (users) in
            self.allUsers = users
            self.allUsers = self.allUsers.filter { $0.identifier != UserController.shared.currentUserId }
        }
    }
    
    func filterBySearch(term: String){
        self.filteredUsers = allUsers.filter { $0.fullName.lowercaseString.containsString(term.lowercaseString) }
        filterSelectedUsers()
    }
    
    func filterSelectedUsers() {
        selectedMembers.forEach { (user) in
            self.filteredUsers = filteredUsers.filter { $0.identifier != user.identifier }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let user = filteredUsers[indexPath.row]
        selectedMembers.append(user)
        filterSelectedUsers()
        tableView.reloadData()
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    //MARK: - Actions
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        switch memberType {
        case .Searched:
            searchBar.hidden = false
            tableView.reloadData()
        case .Added:
            searchBar.hidden = true
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        guard let searchName = searchBar.text else { return }
        searchBar.resignFirstResponder()
        //fetch users by name
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filterBySearch(searchText)
        tableView.reloadData()
    }
    
    @IBAction func DoneButtonTapped(sender: AnyObject) {
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberType == .Searched ? filteredUsers.count : selectedMembers.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath)
        
        let user = memberType == .Searched ? filteredUsers[indexPath.row] : selectedMembers[indexPath.row]
        cell.textLabel?.text = user.fullName
        
        return cell
    }
    
}
