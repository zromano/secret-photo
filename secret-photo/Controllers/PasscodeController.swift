//
//  PasscodeController.swift
//  secret-photo-album
//
//  Created by Zach Romano on 11/6/19.
//  Copyright © 2019 Zach Romano. All rights reserved.
//

import UIKit
import MapKit

class PasscodeController:  UIViewController, PasscodeViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var passcodeArea: UIView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let frame = passcodeArea.frame
        let passcodeView = PasscodeView(frame: frame)
        passcodeView.delegate = self
        view.addSubview(passcodeView)
        passcodeView.becomeFirstResponder()
        
        
        // set a password if they haven't already or if they exited before confirming
        let userDefaults = UserDefaults.standard
        if (!userDefaults.bool(forKey: "hasEnteredPasscodeOnce") || !userDefaults.bool(forKey: "hasConfirmedPasscode")) {
            userDefaults.set(false, forKey: "hasEnteredPasscodeOnce")
            userDefaults.set(false, forKey: "hasConfirmedPasscode")
            messageLabel.text = "Please set your passcode!"
        }
    }
    
    func passcodeView(_ passcodeView: PasscodeView, finishedWithPasscode passcode: String) {
        let userDefaults = UserDefaults.standard
        
        // if they entered the passcode for the first time:
        if (!userDefaults.bool(forKey: "hasEnteredPasscodeOnce")) {
            userDefaults.set(true, forKey: "hasEnteredPasscodeOnce")
            userDefaults.set(passcode, forKey: "firstPasscodeEntered")
            messageLabel.text = "Please confirm your passcode!"
            passcodeView.clear()
            return
        }
        
        // if they are confirming the passcode:
        if (!userDefaults.bool(forKey: "hasConfirmedPasscode")) {
            
            // if the passcode didn't match the first one:
            if (userDefaults.string(forKey: "firstPasscodeEntered") != passcode) {
                let title = "Passcodes didn't match!"
                let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in passcodeView.clear() })
                present(alert, animated: true)
                userDefaults.set(false, forKey: "hasEnteredPasscodeOnce")
                userDefaults.set(false, forKey: "hasConfirmedPasscode")
                messageLabel.text = "Please set your passcode!"
                return
            }
            
            userDefaults.set(passcode, forKey: "passcode")
            userDefaults.set(true, forKey: "hasConfirmedPasscode")
            
            // Request Access to use the user's location
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        if (passcode == userDefaults.string(forKey: "passcode")) {
            self.performSegue(withIdentifier: "showAlbumSelectionSegue", sender: self)
        } else {
            // Invalid Login:
            // log an invalid login attempt
            if CLLocationManager.locationServicesEnabled()  &&
                CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                
                let latitude = locationManager.location?.coordinate.latitude
                let longitude = locationManager.location?.coordinate.longitude
                
                if (latitude != nil && longitude != nil) {
                    InvalidLoginRepository.saveInvalidLogin(latitude: latitude!, longitude: longitude!)
                }
                
            }
            
            // Show wrong alert and clear passcode
            let title = "Wrong!"
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in passcodeView.clear() })
            present(alert, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
