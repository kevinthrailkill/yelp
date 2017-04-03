//
//  FilterPreferences.swift
//  Yelpr
//
//  Created by Kevin Thrailkill on 4/2/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import Foundation


struct FilterPreferences {
    
    var hasDeal = true
    var distanceAway : YelpDistanceAway = .auto
    var sortValue : YelpSortDescriptor = .bestMatched
    
    var distanceInMeters : Double {
        get {
            switch distanceAway {
            case .closest:
                return 482.803
            case .mileAway:
                return 1609.34
            case .farther:
                return 8046.72
            case .farAway:
                return 32186.9
            default:
                //should never get here
                return -1.0
            }
        }
    }
    
    
   
    
}

enum YelpSortDescriptor : Int {
    case bestMatched = 0, distance, highestRated
}

enum YelpDistanceAway : Int {
    case auto = 0
    case closest
    case mileAway
    case farther
    case farAway
}
