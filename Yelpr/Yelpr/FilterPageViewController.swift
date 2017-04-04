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
    var selectedDistanceRow : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }else if section == 1 {
            return 5
        }else if section == 2 {
            return 3
        }else if section == 3 {
            return categories.count
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return nil
        }else if section == 1 {
            return "Distance"
        }else if section == 2 {
            return "Sort By"
        } else if section == 3 {
            return "Categories"
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?{
        if indexPath.section == 0 || indexPath.section == 3 {
            return nil
        }
        
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DealsCell", for: indexPath) as! DealsCell
            cell.dealSwitch.isOn = filterPreferences!.hasDeal
            cell.delegate = self
            
            
            return cell

        }else if section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceCell", for: indexPath) as! DistanceCell
            
            let disVal = YelpDistanceAway(rawValue: indexPath.row)
            
            cell.distanceLabel.text = disVal!.description
            if disVal == filterPreferences!.distanceAway {
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
            
            return cell

            
        }else if section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SortCell", for: indexPath) as! SortCell
            
            
            let sortVal = YelpSortDescriptor(rawValue: indexPath.row)
            
            cell.sortLabel.text = sortVal!.description
            if sortVal == filterPreferences!.sortValue {
                cell.accessoryType = .checkmark
            }else{
                cell.accessoryType = .none
            }
            
            return cell
        } else if section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            
            
            cell.categoryLabel.text = categories[indexPath.row]["name"]
            cell.delegate = self
            
            return cell
        }
        
        

        return UITableViewCell()
        
    }
    
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section
        
        
        let numberOfRows = tableView.numberOfRows(inSection: section)
        for row in 0..<numberOfRows {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) {
                cell.accessoryType = row == indexPath.row ? .checkmark : .none
                
            }
        }
        
        if section == 1 {
            filterPreferences!.distanceAway = YelpDistanceAway(rawValue: indexPath.row)!
            
        }
        
        if section == 2 {
            filterPreferences!.sortValue = YelpSortDescriptor(rawValue: indexPath.row)!
        }
        
    }


}


extension FilterPageViewController : DealsCellDelegate, CategoryCellDelegate {
    func dealSwitchChanged(val: Bool) {
        filterPreferences!.hasDeal = val
        print(filterPreferences!.hasDeal)
    }
    
    func category(cell: CategoryCell, didChangeValue value: Bool) {
        print(cell.categoryLabel.text)
        print(value)
    }
    
    
}


