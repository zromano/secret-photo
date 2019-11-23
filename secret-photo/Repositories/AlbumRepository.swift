//
//  AlbumRepository.swift
//  secret-photo
//
//  Created by Zach Romano on 11/22/19.
//  Copyright © 2019 Zach Romano. All rights reserved.
//


import CoreData
import UIKit

class AlbumRepository {
    /*
     return all album names by Album from CoreData
     */
    static func getAllAlbumNames() -> [String] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Album> = Album.fetchRequest()
        do {
            let albums = try context.fetch(fetchRequest)
            var albumNames: [String] = []
            for album in albums {
                if (album.name != nil) {
                    albumNames.append(album.name!)
                }
            }
            return albumNames
        } catch {
            print("error is \(error)")
            return []
        }
    }
    
    /*
     save a new Album to CoreData
     */
    static func saveAlbum(albumName: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newAlbum = NSEntityDescription.insertNewObject(forEntityName: "Album", into: context) as! Album
        
        newAlbum.name = albumName
        
        appDelegate.saveContext()
    }
}

