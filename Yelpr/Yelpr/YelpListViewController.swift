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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let yelp = YelpNetworkService.init()
        
        yelp.getBusinesses() {
            response in
            if let businesses = response {
                print(businesses)
                self.businessList = businesses
                self.businessListTableView.reloadData()
                
            }else{
                //error
                print("error")
            }
            
        }
        
        // Do any additional setup after loading the view, typically from a nib.
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

