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
    
    

    func getBusinesses(completion: @escaping ([Business]?) -> ()) {
        
        let parameters: [String : String] = ["ll": "37.785771,-122.406165"]
        
        sessionManager.request("https://api.yelp.com/v2/search/", parameters: parameters).responseArray(queue: DispatchQueue.main, keyPath: "businesses", options: JSONSerialization.ReadingOptions.allowFragments) { (response: DataResponse<[Business]>) in
            
            if(response.result.isFailure){
                completion(nil)
            }else{
                let businesses = response.result.value
                completion(businesses)
            }
        }
    }

    


}
