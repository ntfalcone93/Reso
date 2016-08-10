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
    
    var selectedMembers = [User]()
    
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var datePickerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "ResoBackground"))
        //self.navigationController!.view.backgroundColor = UIColor.clearColor()
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    func createOptions() {
        if let option1Cell = option1Cell, name = option1Cell.textField.text {
            options.append(Option(name: name))
        }
        if let option2Cell = option2Cell, name = option2Cell.textField.text {
            options.append(Option(name: name))
        }
        if let option3Cell = option3Cell, name = option3Cell.textField.text {
            options.append(Option(name: name))
        }
        if let option4Cell = option4Cell, name = option4Cell.textField.text {
            options.append(Option(name: name))
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func createPollTapped(sender: AnyObject) {
        guard let title = titleTextFieldCell?.textField.text else {
            return
        }
        createOptions()
        var memberIds = members.flatMap { $0.identifier }
        memberIds.append(UserController.shared.currentUserId)
        guard options.count >= 2 else {
            return
        }
        PollController.create(title, options: options, memberIds: memberIds, pollType: pollType, endDate: datePicker.date)
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pickerViewDoneButtonTapped(sender: AnyObject) {
        endDateTextFieldCell?.textField.text = "\(datePicker.date)"
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
                titleCell.textField.placeholder = "Poll title"
                
                return titleCell
            default:
                let endDateCell = tableView.dequeueReusableCellWithIdentifier("textfieldCell", forIndexPath: indexPath) as? TextfieldTableViewCell ?? TextfieldTableViewCell()
                endDateCell.textField.placeholder = "Poll deadline"
                endDateCell.textField.inputView = datePickerView
                endDateTextFieldCell = endDateCell
                
                return endDateCell
            }
        case 1:
            switch indexPath.row {
            case 0:
                let optionCell = tableView.dequeueReusableCellWithIdentifier("optionCell", forIndexPath: indexPath) as? OptionTableViewCell ?? OptionTableViewCell()
                optionCell.setupCell(indexPath.row + 1)
                option1Cell = optionCell
                
                return optionCell
            case 1:
                let optionCell = tableView.dequeueReusableCellWithIdentifier("optionCell", forIndexPath: indexPath) as? OptionTableViewCell ?? OptionTableViewCell()
                optionCell.setupCell(indexPath.row + 1)
                option2Cell = optionCell
                
                return optionCell
            case 2:
                let optionCell = tableView.dequeueReusableCellWithIdentifier("optionCell", forIndexPath: indexPath) as? OptionTableViewCell ?? OptionTableViewCell()
                optionCell.setupCell(indexPath.row + 1)
                option3Cell = optionCell
                
                return optionCell
            default:
                let optionCell = tableView.dequeueReusableCellWithIdentifier("optionCell", forIndexPath: indexPath) as? OptionTableViewCell ?? OptionTableViewCell()
                optionCell.setupCell(indexPath.row + 1)
                option4Cell = optionCell
                
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
                if members.count > 1 {
                    let member = members[indexPath.row]
                    memberCell.textLabel?.text = member.discreetName
                    memberCell.imageView?.image = member.photo
                } else {
                    memberCell.textLabel?.text = ""
                }
                
                return memberCell
            }
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //change background color of header
        optionHeaderCell?.backgroundColor = UIColor.clearColor()
        
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
            
            return headerCell
        default:
            guard let headerCell = tableView.dequeueReusableCellWithIdentifier("headerCell") as? HeaderTableViewCell else {
                return HeaderTableViewCell()
            }
            headerCell.headerType = .Member
            
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
