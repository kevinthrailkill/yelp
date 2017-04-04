//
//  BusinessCell.swift
//  Yelpr
//
//  Created by Kevin Thrailkill on 4/2/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit
import AFNetworking

/// Business cell for the business list view
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    /// When the Business is set, the cell is configured below
    func configureCell(){
        
        nameLabel.text = business.name
        reviewCountLabel.text = "\(business.reviewCount!) Reviews"
        addressLabel.text = getShortAddressString(location: business.bizLocation)
        categoriesLabel.text = getCategoryString(cats: business.categories)
        distanceLabel.text = getDistanceString(dis: business.distanceInMeters)
        
        if let image = business.imageURLString {
            businessImageView.setImageWith(URL(string: "\(image)")!)
        }
        
        if let ratings = business.ratingImageURLString {
            ratingImageView.setImageWith(URL(string: "\(ratings)")!)
        }
        
        businessImageView.layer.cornerRadius = 3
        businessImageView.clipsToBounds = true
    }
    
}
