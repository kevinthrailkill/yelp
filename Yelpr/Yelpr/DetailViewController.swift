//
//  DetailViewController.swift
//  Yelpr
//
//  Created by Kevin Thrailkill on 4/3/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    var business : Business?
    
    @IBOutlet weak var thumbNailImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var addressTextView: UITextView!
    
    @IBOutlet weak var phoneNumberTextView: UITextView!
    
    @IBOutlet weak var phoneNumberHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var addressHeightContraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureView()
        thumbNailImageView.layer.cornerRadius = 3
        thumbNailImageView.clipsToBounds = true
        
        print(business!)

        // Do any additional setup after loading the view.
    }
    
    
    func configureView(){
        nameLabel.text = business!.name
        reviewCountLabel.text = "\(business!.reviewCount!) Reviews"
        //addressLabel.text = getAddressString(location: business!.bizLocation)
        categoryLabel.text = getCategoryString(cats: business!.categories)
        distanceLabel.text = getDistanceString(dis: business!.distanceInMeters)
        
        addressTextView.text = getAddressString(location: business!.bizLocation)
        
        let fixedWidth = addressTextView.frame.size.width
        addressTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = addressTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = addressTextView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        addressHeightContraint.constant = newSize.height
        
        addressTextView.frame = newFrame;
        
        
        
        if let image = business!.imageURLString {
            thumbNailImageView.setImageWith(URL(string: "\(image)")!)
        }
        
        if let ratings = business!.ratingImageURLString {
            ratingImageView.setImageWith(URL(string: "\(ratings)")!)
        }
        
        
        if let phone = business!.phoneNumber {
            phoneNumberTextView.text = phone
        }else{
            phoneNumberTextView.isHidden = true
            phoneNumberHeightConstraint.constant = 4.0
        }

    }
    
    private func getAddressString(location: BusinessLocation?) -> String {
        if let bizloc = location {
            var address = ""
            
            if let fullAddress = bizloc.fullAddress {
                if fullAddress.count > 0 {
                    for (index, addPart) in fullAddress.enumerated() {
                        if(index != 1) {
                            address += addPart
                            address += "\n"
                        }
                    }
                    return address.substring(to: address.index(before: address.endIndex))
                }
                
            }else{
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
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
