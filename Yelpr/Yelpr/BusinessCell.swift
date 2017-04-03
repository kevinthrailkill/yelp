//
//  BusinessCell.swift
//  Yelpr
//
//  Created by Kevin Thrailkill on 4/2/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    
    var business : Business! {
        didSet {
            configureCell()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        businessImageView.layer.cornerRadius = 3
        businessImageView.clipsToBounds = true
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(){
        
        nameLabel.text = business.name
        reviewCountLabel.text = "\(business.reviewCount!) Reviews"
        addressLabel.text = getAddressString(location: business.bizLocation)
        categoriesLabel.text = getCategoryString(cats: business.categories)
        distanceLabel.text = getDistanceString(dis: business.distanceInMeters)
        
        if let image = business.imageURLString {
            businessImageView.setImageWith(URL(string: "\(image)")!)
        }
        
        if let ratings = business.ratingImageURLString {
            ratingImageView.setImageWith(URL(string: "\(ratings)")!)
        }
        
    }
    
    private func getAddressString(location: BusinessLocation?) -> String {
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
        return "No Address, Most likely error"
    }
    
    private func getCategoryString(cats: [[String]]?) -> String {
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

    private func getDistanceString(dis: Double?) -> String {
        if let distance = dis {
            let milesPerMeter = 0.000621371
            return String(format: "%.2f mi", milesPerMeter * distance)
        }
        return ""
    }
}
