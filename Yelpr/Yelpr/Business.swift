//
//  File.swift
//  Yelpr
//
//  Created by Kevin Thrailkill on 4/2/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import Foundation
import Unbox

struct Business : Unboxable {
    
    let name: String
    let address: String
    let neighborhoods: [String]?
    let imageURLString: String?
    let categories: [[String]]?
    let distanceInMeters: Double?
    let ratingImageURLString: String?
    let reviewCount: Int?
    
    init(unboxer: Unboxer) throws {
        self.name = try unboxer.unbox(key: "name")
        self.address = try unboxer.unbox(key: "address")
        self.neighborhoods = unboxer.unbox(key: "neighborhoods")
        self.imageURLString = unboxer.unbox(key: "image_url")
        self.categories = unboxer.unbox(key: "categories")
        self.distanceInMeters = unboxer.unbox(key: "distance")
        self.ratingImageURLString = unboxer.unbox(key: "rating_img_url_large")
        self.reviewCount = unboxer.unbox(key: "review_count")
        
    }

}
