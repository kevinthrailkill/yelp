//
//  CellStringFormatterFucntions.swift
//  Yelpr
//
//  Created by Kevin Thrailkill on 4/4/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import Foundation


func getShortAddressString(location: BusinessLocation?) -> String {
    if let bizloc = location {
        var address = ""
        
        if let addressArray = bizloc.address {
            if addressArray.count > 0 {
                address = addressArray[0]
            }
        }
        
        if let neighborhoodArray = bizloc.neighborhoods {
            if neighborhoodArray.count > 0 {
                if !address.isEmpty {
                    address += ", "
                }
                address += neighborhoodArray[0]
            }
        }
        return address
        
    }
    return "No Address"
}


func getFullAddressString(location: BusinessLocation?) -> String {
    if let bizloc = location {
        var address = ""
        
        if let fullAddress = bizloc.fullAddress {
            if fullAddress.count > 0 {
                for addPart in fullAddress {
                    
                    if let neighborhoods = location?.neighborhoods, !neighborhoods.contains(addPart) {
                        address += addPart
                        address += "\n"
                    }else{
                        address += addPart
                        address += "\n"
                    }
                    
                }
                return address.substring(to: address.index(before: address.endIndex))
            }
        }
    }
    return "No Address"
}




func getCategoryString(cats: [[String]]?) -> String {
    if let categories = cats {
        var categoryNames = [String]()
        for category in categories {
            let categoryName = category[0]
            categoryNames.append(categoryName)
        }
        return categoryNames.joined(separator: ", ")
    }
    return ""
}

func getDistanceString(dis: Double?) -> String {
    if let distance = dis {
        let milesPerMeter = 0.000621371
        return String(format: "%.2f mi", milesPerMeter * distance)
    }
    return ""
}

