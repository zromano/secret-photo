//
//  InvalidLoginRepository.swift
//  secret-photo
//
//  Created by Zach Romano on 11/25/19.
//  Copyright © 2019 Zach Romano. All rights reserved.
//

import CoreData
import UIKit

class InvalidLoginRepository {
    /*
     return all Invalid Logins from CoreData
     */
    static func getAllInvalidLogins() -> [InvalidLogin] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<InvalidLogin> = InvalidLogin.fetchRequest()
        do {
            let invalidLogins = try context.fetch(fetchRequest)
            return invalidLogins
        } catch {
            print("error is \(error)")
            return []
        }
    }
    
    /*
     save a new Album to CoreData
     */
    static func saveInvalidLogin(latitude: Double, longitude: Double) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newInvalidLogin = NSEntityDescription.insertNewObject(forEntityName: "InvalidLogin", into: context) as! InvalidLogin
        
        newInvalidLogin.dateAccessed = Date()
        newInvalidLogin.latitude = latitude
        newInvalidLogin.longitude = longitude
        
        appDelegate.saveContext()
    }
}

