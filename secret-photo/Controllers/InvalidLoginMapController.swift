//
//  InvalidLoginMapController.swift
//  secret-photo
//
//  Created by Zach Romano on 11/25/19.
//  Copyright © 2019 Zach Romano. All rights reserved.
//

import UIKit
import MapKit

class InvalidLoginMapController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mkView: MKMapView!
    
    override func viewDidLoad() {
        // query the database and get data then add map annotations
        let invalidLocations = InvalidLoginRepository.getAllInvalidLogins()
        invalidLocations.forEach({ invalidLocation in
            mkView.addAnnotation(InvalidLocationPin(invalidLogin: invalidLocation))
        })
    }
    
    /*
     Make all item locations have a callout and a button.
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? InvalidLocationPin {
            let identifier = "pin"
            var view: MKAnnotationView
            // don't reuse because the colors change
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view = pinView
//            view.canShowCallout = true
//            view.calloutOffset = CGPoint(x: -5, y: 5)
//            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//            let imageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 53, height: 53))
//            imageView.image = UIImage(named: annotation.item.imageName ?? "default")
//            view.leftCalloutAccessoryView = imageView
            return view
        }
        return MKPinAnnotationView()
    }
}
