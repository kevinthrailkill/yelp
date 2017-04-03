//
//  FilterPageViewController.swift
//  Yelpr
//
//  Created by Kevin Thrailkill on 4/2/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit

class FilterPageViewController: UITableViewController {

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    @IBAction func searchWithFilter(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
        filterDelegate?.searchWith(filters: filterPreferences!)
    }
    
    var filterPreferences : FilterPreferences?
    weak var filterDelegate: YelpFilterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let checkedDistanceCell = tableView.cellForRow(at: IndexPath(row: (filterPreferences?.distanceAway.rawValue)!, section: 1))
        
        checkedDistanceCell?.accessoryType = UITableViewCellAccessoryType.checkmark
        
        let checkedSortByCell = tableView.cellForRow(at: IndexPath(row: (filterPreferences?.sortValue.rawValue)!, section: 2))
        
        checkedSortByCell?.accessoryType = UITableViewCellAccessoryType.checkmark
        
        
    }
    
    @IBAction func hasDealChanged(_ sender: UISwitch) {
        filterPreferences?.hasDeal = sender.isOn
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let numberOfRows = tableView.numberOfRows(inSection: section)
        for row in 0..<numberOfRows {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) {
                cell.accessoryType = row == indexPath.row ? .checkmark : .none
            }
        }
        
        if section == 1 {
            filterPreferences?.distanceAway = YelpDistanceAway(rawValue: indexPath.row)!
        }
        
        if section == 2 {
            filterPreferences?.sortValue = YelpSortDescriptor(rawValue: indexPath.row)!
        }
        
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
