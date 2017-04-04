//
//  DetailViewController.swift
//  Yelpr
//
//  Created by Kevin Thrailkill on 4/3/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit
import MapKit


/// Detail View Page
class DetailViewController: UIViewController, MKMapViewDelegate {

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
    @IBOutlet weak var businessMapView: MKMapView!
    
    var business : Business?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    
    
    /// Configures the detail view
    func configureView(){
        
        nameLabel.text = business!.name
        reviewCountLabel.text = "\(business!.reviewCount!) Reviews"
        categoryLabel.text = getCategoryString(cats: business!.categories)
        distanceLabel.text = getDistanceString(dis: business!.distanceInMeters)
        addressTextView.text = getFullAddressString(location: business!.bizLocation)
        
        //sets the height of the text label for the address
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
        
        
        if let coordinateDictionary = business!.bizLocation?.coordinate {
            let initialLocation = CLLocation(latitude: coordinateDictionary["latitude"]!, longitude: coordinateDictionary["longitude"]!)
            
            centerMapOnLocation(location: initialLocation)
        } else{
            businessMapView.setCenter(businessMapView.userLocation.coordinate, animated: true)
        }
        
        thumbNailImageView.layer.cornerRadius = 3
        thumbNailImageView.clipsToBounds = true

    }
    
    
    /// Sets a pin on the map view and centers where business should be
    ///
    /// - Parameter location: the location of the business
    func centerMapOnLocation(location: CLLocation) {
        
        let annotation = MKPointAnnotation()
        let centerCoordinate = location.coordinate
        annotation.coordinate = centerCoordinate
        businessMapView.addAnnotation(annotation)
        
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        businessMapView.setRegion(coordinateRegion, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

