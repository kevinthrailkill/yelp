//
//  YelpNetworkService.swift
//  Yelpr
//
//  Created by Kevin Thrailkill on 4/2/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import Foundation
import Alamofire
import UnboxedAlamofire
import OAuthSwift
import OAuthSwiftAlamofire
import MapKit

fileprivate let yelpConsumerKey = "Ud2_KGByd9GxXjjQs82_Uw"
fileprivate let yelpConsumerSecret = "290wZFJ-pKbF2SrTlkdNKUnFWlo"
fileprivate let yelpToken = "i9fxxV5LcwBF7Jt9WhW93m4csqvsW0Lu"
fileprivate let yelpTokenSecret = "vFg2CfAO3DTr6mczF2uC36aVb40"

class YelpNetworkService {
    
    let sessionManager = SessionManager.default
    
    
    init() {
        let oauthswift = OAuth1Swift(
            consumerKey: yelpConsumerKey,
            consumerSecret: yelpConsumerSecret,
            requestTokenUrl: "https://api.twitter.com/oauth/request_token",
            authorizeUrl:    "https://api.twitter.com/oauth/authorize",
            accessTokenUrl:  "https://api.twitter.com/oauth/access_token")
        
        oauthswift.client.credential.oauthToken = yelpToken
        oauthswift.client.credential.oauthTokenSecret = yelpTokenSecret

        sessionManager.adapter = OAuthSwiftRequestAdapter(oauthswift)
        
    }

    func getBusinesses(text: String, location: CLLocation, offset: Int, filters: FilterPreferences, completion: @escaping ([Business]?) -> ()) {
        
        //location set to sf - need to change to use users location
        
        let limit = 20
        
        let locationString = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        
        var parameters: [String : AnyObject] = ["term": text as AnyObject, "ll": locationString as AnyObject, "sort": filters.sortValue.rawValue as AnyObject , "limit": limit as AnyObject, "offset" : limit * offset as AnyObject]
        
        if filters.distanceAway.rawValue != 0 {
            parameters["radius_filter"] = filters.distanceInMeters as AnyObject
        }
        
        parameters["deals_filter"] = filters.hasDeal as AnyObject
        
        
        
        if filters.categories.count > 0 {
            parameters["category_filter"] = (filters.categories).joined(separator: ",") as AnyObject
        }

        
        
        sessionManager.request("https://api.yelp.com/v2/search/", parameters: parameters).responseArray(queue: DispatchQueue.main, keyPath: "businesses", options: JSONSerialization.ReadingOptions.allowFragments) { (response: DataResponse<[Business]>) in
            
            if response.result.isFailure {
                completion(nil)
            }else {
                let businesses = response.result.value
                completion(businesses)
            }
        }
    }
    
}
