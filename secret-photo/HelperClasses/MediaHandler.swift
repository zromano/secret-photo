//
//  MediaHandler.swift
//  secret-photo
//
//  Created by Zach Romano on 11/28/19.
//  Copyright © 2019 Zach Romano. All rights reserved.
//

import UIKit

class MediaHandler {
    
    static func loadImageFromDiskWith(fileName: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }
    
    static func saveImage(imageName: String, image: UIImage) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileURL = documentsDirectory.appendingPathComponent(imageName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch let error {
                print(error)
            }
        }
        do {
            try data.write(to: fileURL)
        } catch let error {
            print(error)
        }
    }
    
    static func deleteMediaFile(fileName: String) -> Bool {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return false}
        
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                return true
            } catch let error {
                print(error)
                return false
            }
        } else {
            return false
        }
    }
    
    static func deleteImageOrVideo(imageName: ImageName) -> Bool {
        var successful: Bool = true
        if (imageName.isVideo) {
            successful = successful && self.deleteMediaFile(fileName: imageName.videoUrl!)
        }
        successful = successful && self.deleteMediaFile(fileName: imageName.imageUrl!)
        successful = successful && ImageNameRepository.deleteImageInfo(imageName: imageName.imageUrl!)
        return successful
    }
    
    static func deleteFolder(albumName: String) -> Bool {
        var successful: Bool = true
        let imageNames: [ImageName] = ImageNameRepository.getAllImageNamesByAlbum(albumName: albumName)
        
        for imageName in imageNames {
            successful = successful && self.deleteImageOrVideo(imageName: imageName)
        }
        successful = successful && AlbumRepository.deleteAlbum(albumName: albumName)
        
        return successful
    }
}
