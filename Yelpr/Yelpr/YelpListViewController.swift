//
//  YelpListViewController.swift
//  Yelpr
//
//  Created by Kevin Thrailkill on 4/2/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit
import CoreLocation


protocol YelpFilterDelegate : class {
    func searchWith(filters: FilterPreferences)
}

class YelpListViewController: UIViewController {

    @IBOutlet weak var businessListTableView: UITableView!
    
    var businessList : [Business] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    let yelpService = YelpNetworkService.init()
    var filterPreferences = FilterPreferences()
    var locationManager: CLLocationManager!
    var offset = 0
    
    
    
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
        
        textFieldInsideSearchBar?.placeholder = "Restaurants"
        textFieldInsideSearchBar?.font = UIFont(name: "Gill Sans", size: 13.0)
        textFieldInsideSearchBar?.textColor = UIColor(red: 0, green: 0.263, blue: 0.337, alpha: 1.0)
        
        definesPresentationContext = true
        navigationItem.titleView = searchController.searchBar
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }

        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let initialLocation = locationManager.location!
        
        searchYelpFor(searchText: "", location: initialLocation)


    }
    
    func searchYelpFor(searchText: String, location: CLLocation) {
        yelpService.getBusinesses(text: searchText, location: location, offset: offset, filters:filterPreferences) {
            response in
            if let businesses = response {
                self.businessList = businesses
                self.businessListTableView.reloadData()
                
                if businesses.count > 0 {
                    self.businessListTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: true)
                }
                
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FilterPageSegue" {
            let filterNavController = segue.destination
                as! UINavigationController
            
            let filterViewController = filterNavController.viewControllers[0] as! FilterPageViewController
            filterViewController.filterPreferences = filterPreferences
            filterViewController.filterDelegate = self
            
        }else if segue.identifier == "DetailPageSegue" {
            let detailController = segue.destination
                as! DetailViewController
            let selectedIndex = businessListTableView.indexPath(for: sender as! UITableViewCell)
            
            detailController.business = businessList[(selectedIndex?.row)!]
        }
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
            searchYelpFor(searchText: searchController.searchBar.text!, location: locationManager.location!)
        }else{
            searchYelpFor(searchText: "", location: locationManager.location!)
        }
    }
}

extension YelpListViewController : YelpFilterDelegate {
    func searchWith(filters: FilterPreferences) {
        filterPreferences = filters
        searchYelpFor(searchText: searchController.searchBar.text!, location: locationManager.location!)
        
    }
}

extension YelpListViewController : CLLocationManagerDelegate {
    
}

