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
    
    static func saveImage(albumName: String, imageUrl: String) -> ImageName {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newImage = NSEntityDescription.insertNewObject(forEntityName: "ImageName", into: context) as! ImageName
        
        newImage.album = albumName
        newImage.imageUrl = imageUrl
        newImage.isVideo = false
        
        appDelegate.saveContext()
        
        return newImage
    }
    
    static func saveVideo(albumName: String, thumbnailUrl: String, videoUrl: String) -> ImageName {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newImage = NSEntityDescription.insertNewObject(forEntityName: "ImageName", into: context) as! ImageName
        
        newImage.album = albumName
        newImage.imageUrl = thumbnailUrl
        newImage.isVideo = true
        newImage.videoUrl = videoUrl
        
        appDelegate.saveContext()
        
        return newImage
    }
    
    static func deleteImageInfo(imageName: String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ImageName> = ImageName.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imageUrl == %@", imageName)
        do {
            let imageNames = try context.fetch(fetchRequest)
            for imageName in imageNames {
                context.delete(imageName)
            }
            return true
        } catch {
            print("error is \(error)")
            return false
        }
    }
    
    /*
     update album name for all images in an album
     */
    static func updateAlbumNameForImagesInAlbum(oldAlbumName: String, newAlbumName: String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ImageName> = ImageName.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "album == %@", oldAlbumName)
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count != 0 {
                for image in results {
                    image.setValue(newAlbumName, forKey: "album")
                }
            } else {
                return false
            }
        } catch {
            print("Fetch Failed: \(error)")
            return false
        }
        
        do {
            try context.save()
            return true
        }
        catch {
            print("Saving Core Data Failed: \(error)")
            return false
        }
    }
    
    static func getFirstPhotoInAlbum(albumName: String) -> String? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageName")
        fetchRequest.predicate = NSPredicate(format: "album == %@", albumName)
        do {
            let imageNames = try context.fetch(fetchRequest)
            if (imageNames.count > 0) {
                let imageInfo = imageNames[0] as! ImageName
                return imageInfo.imageUrl
            } else {
                return nil
            }
        } catch {
            print("error is \(error)")
            return nil
        }
    }
}
