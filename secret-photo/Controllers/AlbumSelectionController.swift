//
//  AlbumSelectionController.swift
//  secret-photo
//
//  Created by Zach Romano on 11/22/19.
//  Copyright © 2019 Zach Romano. All rights reserved.
//

import UIKit

class AlbumSelectionController: UITableViewController {
    
    var albums : [Album] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        AlbumRepository.saveAlbum(albumName: "Album1")
        albums = AlbumRepository.getAllAlbums()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumTableCellReuseIdentifier", for: indexPath)
        
        let albumName = albums[indexPath.row].name
        let numImagesInAlbum: Int = ImageNameRepository.getNumberOfImagesByAlbum(albumName: albumName!)
        
        cell.textLabel?.text = albumName! + " (" + String(numImagesInAlbum) + ")"
        cell.imageView?.image = UIImage(named: "arch")
        
        let itemSize = CGSize.init(width: 35, height: 35)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
        let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
        cell.imageView?.image!.draw(in: imageRect)
        cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showAlbumSegue") {
            let albumView: AlbumController = segue.destination as! AlbumController
            let indexPath: NSIndexPath = self.tableView.indexPath(for: sender as! UITableViewCell)! as NSIndexPath
            albumView.albumName = albums[indexPath.row].name!
        }
    }
}
