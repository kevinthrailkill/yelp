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
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    
    
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
        
        
        searchYelpFor(searchText: "")
        
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: businessListTableView.contentSize.height, width: businessListTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        businessListTableView.addSubview(loadingMoreView!)
        
        var insets = businessListTableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        businessListTableView.contentInset = insets


    }
    
    func searchYelpFor(searchText: String) {
        yelpService.getBusinesses(text: searchText, location: locationManager.location!, offset: offset, filters:filterPreferences) {
            response in
            if let businesses = response {
                self.businessList = businesses
                self.businessListTableView.reloadData()
                
              //  if businesses.count > 0 {
               //     self.businessListTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: true)
              //  }
                
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
        offset = 0
        if(searchController.searchBar.text!.characters.count > 0){
            searchYelpFor(searchText: searchController.searchBar.text!)
        }else{
            searchYelpFor(searchText: "")
        }
    }
}

extension YelpListViewController : YelpFilterDelegate {
    func searchWith(filters: FilterPreferences) {
        offset = 0
        filterPreferences = filters
        searchYelpFor(searchText: searchController.searchBar.text!)
    }
}

extension YelpListViewController : CLLocationManagerDelegate {
    
}

extension YelpListViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = businessListTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - businessListTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && businessListTableView.isDragging) {
                isMoreDataLoading = true
                offset += 1
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: businessListTableView.contentSize.height, width: businessListTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                loadMoreData()		
            }
        }
    }
    
    func loadMoreData() {
        
        yelpService.getBusinesses(text: searchController.searchBar.text!, location: locationManager.location!, offset: offset, filters:filterPreferences) {
            response in
            if let businesses = response {
                
                // Update flag
                self.isMoreDataLoading = false
                
                // Stop the loading indicator
                self.loadingMoreView!.stopAnimating()
                
                self.businessList.append(contentsOf: businesses)
                self.businessListTableView.reloadData()
                
                
            }else{
                //error
                print("error")
            }
            
        }

        
    }
    
    
    
}




