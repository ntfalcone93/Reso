//
//  PollCreateTableViewController.swift
//  Reso
//
//  Created by Nathan on 8/9/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import UIKit

class PollCreateTableViewController: UITableViewController {
    
    var options = [Option]()
    var optionCount = 2
    var members = [User]()
    var pollType: PollType = .Private
    // Text field cells
    var titleTextFieldCell: TextfieldTableViewCell?
    var endDateTextFieldCell: TextfieldTableViewCell?
    // Option cells
    var option1Cell: OptionTableViewCell?
    var option2Cell: OptionTableViewCell?
    var option3Cell: OptionTableViewCell?
    var option4Cell: OptionTableViewCell?
    // Header cells
    var optionHeaderCell: HeaderTableViewCell?
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var datePickerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "ResoBackground"))
        
        datePicker.date = defaultTimeInterval
    }
    
    
    let defaultTimeInterval = NSDate(timeIntervalSinceNow: 86400)
    let minTimeInterval = NSDate(timeIntervalSinceNow: 300)
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func createOptions() {
        if let option1Cell = option1Cell, name = option1Cell.textField.text where name.characters.count > 0 {
            options.append(Option(name: name))
        }
        if let option2Cell = option2Cell, name = option2Cell.textField.text where name.characters.count > 0 {
            options.append(Option(name: name))
        }
        if let option3Cell = option3Cell, name = option3Cell.textField.text where name.characters.count > 0 {
            options.append(Option(name: name))
        }
        if let option4Cell = option4Cell, name = option4Cell.textField.text where name.characters.count > 0 {
            options.append(Option(name: name))
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func datePickerDoneTapped(sender: AnyObject) {
        endDateTextFieldCell?.textField.text = datePicker.date.stringValue()
        endDateTextFieldCell?.textField.resignFirstResponder()
    }
    
    @IBAction func createPollTapped(sender: AnyObject) {
        // Title
        guard let title = titleTextFieldCell?.textField.text where title.characters.count > 0 else {
            presentPollAlertController("You forgot a poll name.", message: "Please add it to the poll name field.")
            return
        }
        // Members
        guard members.count > 0 else {
            presentPollAlertController("Missing Information", message: "Please add members to your poll.")
            return
        }
        var memberIds = members.flatMap { $0.identifier }
        memberIds.append(UserController.shared.currentUserId)
        // Options
        if option1Cell?.textField.text?.characters.count > 0 && option2Cell?.textField.text?.characters.count > 0 {
            createOptions()
        } else {
            presentPollAlertController("Missing Information", message: "Please add at least two options to your poll.")
        }
        // Create poll
        PollController.create(title, options: options, memberIds: memberIds, pollType: pollType, endDate: datePicker.date)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func userTappedScreen(sender: AnyObject) {
        self.titleTextFieldCell?.resignFirstResponder()
        self.endDateTextFieldCell?.resignFirstResponder()
    }
    
    // MARK: - Alert Controller
    
    func presentPollAlertController(title: String, message: String?){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
        
        alertController.addAction(dismissAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    //MARK: - Segue
    
    //pass added members to pollCreateDetail when user goes back to add additional members
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toAddMembers" {
            if let destinationVC = segue.destinationViewController as? PollCreateDetailTableViewController {
                destinationVC.selectedMembers = members
            }
        }
    }
}


// MARK: - Table view data source and delegate methods

extension PollCreateTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return optionCount
        default:
            return members.count + 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let segmentCell = tableView.dequeueReusableCellWithIdentifier("segmentCell", forIndexPath: indexPath) as? SegmentTableViewCell ?? SegmentTableViewCell()
                segmentCell.delegate = self
                
                return segmentCell
            case 1:
                let titleCell = tableView.dequeueReusableCellWithIdentifier("textfieldCell", forIndexPath: indexPath) as? TextfieldTableViewCell ?? TextfieldTableViewCell()
                titleTextFieldCell = titleCell
                titleCell.textField.placeholder = "Name of your Poll"
                titleCell.textField.autocapitalizationType = UITextAutocapitalizationType.Sentences
                
                return titleCell
            default:
                let endDateCell = tableView.dequeueReusableCellWithIdentifier("textfieldCell", forIndexPath: indexPath) as? TextfieldTableViewCell ?? TextfieldTableViewCell()
                endDateCell.textField.placeholder = "Poll deadline"
                endDateCell.textField.inputView = datePickerView
                endDateCell.textField.text = String("Set poll deadline: \(datePicker.date.stringValue())")
                endDateTextFieldCell = endDateCell
                
                return endDateCell
            }
        case 1:
            switch indexPath.row {
            case 0:
                let optionCell = tableView.dequeueReusableCellWithIdentifier("optionCell", forIndexPath: indexPath) as? OptionTableViewCell ?? OptionTableViewCell()
                optionCell.setupCell(indexPath.row + 1)
                option1Cell = optionCell
                optionCell.textField.autocapitalizationType = UITextAutocapitalizationType.Sentences
                
                return optionCell
            case 1:
                let optionCell = tableView.dequeueReusableCellWithIdentifier("optionCell", forIndexPath: indexPath) as? OptionTableViewCell ?? OptionTableViewCell()
                optionCell.setupCell(indexPath.row + 1)
                option2Cell = optionCell
                optionCell.textField.autocapitalizationType = UITextAutocapitalizationType.Sentences
                
                return optionCell
            case 2:
                let optionCell = tableView.dequeueReusableCellWithIdentifier("optionCell", forIndexPath: indexPath) as? OptionTableViewCell ?? OptionTableViewCell()
                optionCell.setupCell(indexPath.row + 1)
                option3Cell = optionCell
                optionCell.textField.autocapitalizationType = UITextAutocapitalizationType.Sentences
                
                return optionCell
            default:
                let optionCell = tableView.dequeueReusableCellWithIdentifier("optionCell", forIndexPath: indexPath) as? OptionTableViewCell ?? OptionTableViewCell()
                optionCell.setupCell(indexPath.row + 1)
                option4Cell = optionCell
                optionCell.textField.autocapitalizationType = UITextAutocapitalizationType.Sentences
                
                return optionCell
            }
        default:
            switch indexPath.row {
            case 0:
                let addMemberCell = tableView.dequeueReusableCellWithIdentifier("addMemberCell", forIndexPath: indexPath) as? AddMemberTableViewCell ?? AddMemberTableViewCell()
                addMemberCell.delegate = self
                
                return addMemberCell
            default:
                let memberCell = tableView.dequeueReusableCellWithIdentifier("memberCell", forIndexPath: indexPath)
                
                let member = members[indexPath.row - 1]
                memberCell.textLabel?.text = member.discreetName
                memberCell.imageView?.image = member.photo
                
                return memberCell
            }
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            return nil
        case 1:
            guard let headerCell = tableView.dequeueReusableCellWithIdentifier("headerCell") as? HeaderTableViewCell else {
                return HeaderTableViewCell()
            }
            headerCell.delegate = self
            headerCell.headerType = .Option
            optionHeaderCell = headerCell
            headerCell.backgroundColor = .clearColor()
            
            return headerCell
        default:
            guard let headerCell = tableView.dequeueReusableCellWithIdentifier("headerCell") as? HeaderTableViewCell else {
                return HeaderTableViewCell()
            }
            headerCell.headerType = .Member
            headerCell.contentView.backgroundColor = .clearColor()
            
            return headerCell.contentView
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return 44
        }
    }
    
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
        self.tableView.reloadData()
        if let sourceViewController = segue.sourceViewController as? PollCreateDetailTableViewController {
            members = sourceViewController.selectedMembers
            tableView.reloadData()
        }
    }
}

// MARK: - SegmentCellDelegate methods

extension PollCreateTableViewController: SegmentCellDelegate {
    
    func segmentChanged(pollType: PollType) {
        self.pollType = pollType
    }
}

// MARK: - HeaderCellDelegate methods

extension PollCreateTableViewController: HeaderCellDelegate {
    
    func addButtonTapped(headerType: HeaderType) {
        switch headerType {
        case .Option:
            let indexPath = NSIndexPath(forRow: optionCount, inSection: 1)
            optionCount += 1
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            if optionCount == 4 {
                optionHeaderCell?.addButton.hidden = true
            }
        default:
            break
        }
    }
}

extension PollCreateTableViewController: AddMemberCellDelegate {
    
    func addMembers() {
        //performSegueWithIdentifier("toAddMembers", sender: self)
    }
}
