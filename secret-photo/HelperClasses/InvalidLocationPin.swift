//
//  InvalidLocationPin.swift
//  secret-photo
//
//  Created by Zach Romano on 11/25/19.
//  Copyright © 2019 Zach Romano. All rights reserved.
//

import UIKit
import MapKit

class InvalidLocationPin: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(invalidLogin: InvalidLogin) {
        
        // make the title the date
        if (invalidLogin.dateAccessed != nil) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MMM-yyyy"
            let dateString = formatter.string(from: invalidLogin.dateAccessed!)
            self.title = dateString
        } else {
            self.title = "Unknown Date"
        }
        
        let location = CLLocation(latitude: invalidLogin.latitude, longitude: invalidLogin.longitude)
        self.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        
        super.init()
    }
}
