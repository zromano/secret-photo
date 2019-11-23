//
//  ImageNameRepository.swift
//  secret-photo
//
//  Created by Zach Romano on 11/21/19.
//  Copyright © 2019 Zach Romano. All rights reserved.
//

import CoreData
import UIKit

class ImageNameRepository {
    
    static func getNumberOfImagesByAlbum(albumName: String) -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSNumber>(entityName: "ImageName")
        fetchRequest.resultType = .countResultType
        fetchRequest.predicate = NSPredicate(format: "album == %@", albumName)
        do {
            let count = try context.fetch(fetchRequest)
            return count[0].intValue
        } catch {
            print("error is \(error)")
            return -1
        }
    }
    
    /*
     return all image names by Album from CoreData
     */
    static func getAllImageNamesByAlbum(albumName: String) -> [ImageName] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ImageName> = ImageName.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "album == %@", albumName)
        do {
            let imageNames = try context.fetch(fetchRequest)
            return imageNames
        } catch {
            print("error is \(error)")
            return []
        }
    }
    
    static func saveImage(albumName: String, imageUrl: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newImage = NSEntityDescription.insertNewObject(forEntityName: "ImageName", into: context) as! ImageName
        
        newImage.album = albumName
        newImage.imageUrl = imageUrl
        
        appDelegate.saveContext()
    }
}
