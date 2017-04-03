//
//  YelpListViewController.swift
//  Yelpr
//
//  Created by Kevin Thrailkill on 4/2/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit

class YelpListViewController: UIViewController {

    
    @IBOutlet weak var businessListTableView: UITableView!
    
    var businessList : [Business] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    let yelpService = YelpNetworkService.init()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        businessListTableView.rowHeight = UITableViewAutomaticDimension
        businessListTableView.estimatedRowHeight = 120
        
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.barTintColor = UIColor.clear
        searchController.searchBar.backgroundColor = UIColor.clear
        searchController.searchBar.barStyle = .blackTranslucent
        
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        
        textFieldInsideSearchBar?.font = UIFont(name: "Gill Sans", size: 13.0)
        textFieldInsideSearchBar?.textColor = UIColor(red: 0, green: 0.263, blue: 0.337, alpha: 1.0)
        
        definesPresentationContext = true
        navigationItem.titleView = searchController.searchBar

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func searchYelpFor(searchText: String) {
        yelpService.getBusinesses(text: searchText) {
            response in
            if let businesses = response {
                //    print(businesses)
                self.businessList = businesses
                self.businessListTableView.reloadData()
                
            }else{
                //error
                print("error")
            }
            
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension YelpListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businessList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        cell.business = businessList[indexPath.row]
        
        return cell
        
    }
    
}

extension YelpListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if(searchController.searchBar.text!.characters.count > 0){
            searchYelpFor(searchText: searchController.searchBar.text!)
        }else{
            businessList = []
            businessListTableView.reloadData()
        }
    }
    
}

