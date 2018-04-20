//
//  RepeatTableViewController.swift
//  TableViewDemo2
//
//  Created by Hubert Ka on 2018-01-17.
//  Copyright © 2018 Hubert Ka. All rights reserved.
//

import UIKit

class RepeatTableViewController: UITableViewController {

    //MARK: Properties
    private enum Row: Int {
        case never
        case everyDay
        case everyWeek
        case everyTwoWeeks
        case everyMonth
        case everyYear
        
        init(indexPath: IndexPath) {
            var selectedRow: RepeatTableViewController.Row
            
            switch (indexPath.section, indexPath.row) {
            case (0,0):
                selectedRow = Row.never
            case (0,1):
                selectedRow = Row.everyDay
            case (0,2):
                selectedRow = Row.everyWeek
            case (0,3):
                selectedRow = Row.everyTwoWeeks
            case (0,4):
                selectedRow = Row.everyMonth
            case (0,5):
                selectedRow = Row.everyYear
            default:
                fatalError("Unexpected index path: \(indexPath.section, indexPath.row)")
            }
            
            self = selectedRow
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = Row(indexPath: indexPath)
        
        // Loads table with >previously selected cell< or "Never" if no previous selection.
        if row == .never {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            
            // Select "Never" row to allow for didDeselectRowAt delegate method to activate after initializing.
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.bottom)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        // Display checkmark on selected cell.
        if cell?.accessoryType != UITableViewCellAccessoryType.checkmark {
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        
        // Dismisses repeat table view after selecting a repeat option. >> Does not work as repeat table view is not presented modally, will need to use segues.
        //dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        // Hide checkmark on all other cells.
        cell?.accessoryType = UITableViewCellAccessoryType.none
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
