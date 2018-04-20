//
//  DetailsTableViewController.swift
//  TableViewDemo2
//
//  Created by Hubert Ka on 2018-01-12.
//  Copyright © 2018 Hubert Ka. All rights reserved.
//

import UIKit

class DetailsTableViewController: UITableViewController {

    //MARK: Properties
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    private var datePickerIsHidden = true
    private var reminderIsHidden = true
    private var locationIsHidden = true
    
    // Not sure if there is a better way to do this so if a programmer changes the default detail colour in IB, it will reflect that change here, instead of defining text colour explicitly.
    private let detailColor = UIColor.lightGray
    
    private enum Row: Int {
        case reminder
        case remindMeOnDay
        case alarm
        case datePicker
        case repeatAlarm
        case remindMeAtLocation
        case location
        
        init(indexPath: IndexPath) {
            var selectedRow: DetailsTableViewController.Row
            
            switch (indexPath.section, indexPath.row) {
            case (0,0):
                selectedRow = Row.reminder
            case (1,0):
                selectedRow = Row.remindMeOnDay
            case (1,1):
                selectedRow = Row.alarm
            case (1,2):
                selectedRow = Row.datePicker
            case (1,3):
                selectedRow = Row.repeatAlarm
            case (2,0):
                selectedRow = Row.remindMeAtLocation
            case (2,1):
                selectedRow = Row.location
            default:
                fatalError("Unexpected index path: \(indexPath.section, indexPath.row)")
            }
            
            self = selectedRow
        }
    }

    override func viewDidLoad() {
        didChangeDate()
    }
    
    //MARK: Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = Row(indexPath: indexPath)
        
        if row == .alarm {
            toggleDatePicker()
            
            // Highlight date text while using date picker.
            if !datePickerIsHidden {
                dateText.textColor = self.view.tintColor
            }
            else {
                dateText.textColor = detailColor
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = Row(indexPath: indexPath)
        
        // Determine the height for each row. >REFACTOR LATER IF POSSIBLE<
        if datePickerIsHidden && row == .datePicker {
            return 0
        }
        else if reminderIsHidden && (row == .alarm || row == .repeatAlarm || row == .datePicker) {
            // Re-initialize the date picker to default state.
            datePickerIsHidden = true
            dateText.textColor = detailColor
            datePicker.date = .init()
            didChangeDate()
            
            return 0
        }
        else if locationIsHidden && row == .location {
            // Re-initialize the location to default state.
            
            return 0
        }
        else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }

        //return datePickerIsHidden && row == .datePicker ? 0 : super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = Row(indexPath: indexPath)

        // Update separator inset of section title/toggle cell at table view load time.
        if row == .remindMeOnDay || row == .remindMeAtLocation {
            updateSeparatorInset(for: cell, at: indexPath)
        }
    }
    
    //MARK: Actions
    @IBAction func didChangeDate() {
        // Update detail text in alarm cell with the date picker's selection.
        dateText.text = DateFormatter.localizedString(from: datePicker.date, dateStyle: .medium, timeStyle: .short)
    }
    
    @IBAction func didToggleReminder(_ sender: UISwitch) {
        reminderIsHidden = !reminderIsHidden
        updateTableView(sender)
    }
    
    @IBAction func didToggleLocation(_ sender: UISwitch) {
        locationIsHidden = !locationIsHidden
        updateTableView(sender)
    }
    
    //MARK: Private methods
    private func toggleDatePicker() {
        datePickerIsHidden = !datePickerIsHidden
        updateTableView(nil)
    }
    
    private func updateSeparatorInset(for cell: UITableViewCell, at indexPath: IndexPath) {
        let row = Row(indexPath: indexPath)
        
        // Extend separator of section title/toggle cell to screen edge if section is hidden, otherwise conform to table view layout margins default
        if (row == .remindMeOnDay && reminderIsHidden) || (row == .remindMeAtLocation && locationIsHidden) {
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
        else {
            cell.separatorInset = UIEdgeInsetsMake(0, tableView.layoutMargins.left, 0, 0)
        }
    }
    
    private func updateTableView(_ sender: UISwitch?) {
        // Force table to update its contents.
        tableView.beginUpdates()
        tableView.endUpdates()
        
        // Update separator inset of section title/toggle cell.
        if let cell = sender?.superview?.superview as? UITableViewCell {
            guard let indexPath = tableView.indexPath(for: cell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            updateSeparatorInset(for: cell, at: indexPath)
        }
    }
}
