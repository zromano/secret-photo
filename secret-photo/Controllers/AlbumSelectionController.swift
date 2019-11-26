//
//  AlbumSelectionController.swift
//  secret-photo
//
//  Created by Zach Romano on 11/22/19.
//  Copyright © 2019 Zach Romano. All rights reserved.
//

import UIKit

class AlbumSelectionController: UITableViewController {
    
    var albumNames : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumNames = AlbumRepository.getAllAlbumNames()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumNames.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumTableCellReuseIdentifier", for: indexPath)
        
        let albumName = albumNames[indexPath.row]
        let numImagesInAlbum: Int = ImageNameRepository.getNumberOfImagesByAlbum(albumName: albumName)
        
        cell.textLabel?.text = albumName + " (" + String(numImagesInAlbum) + ")"
        cell.imageView?.image = UIImage(named: "default")
        
        let itemSize = CGSize.init(width: 100, height: 100)
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
            albumView.albumName = albumNames[indexPath.row]
        }
    }
    
    
    @IBAction func createNewAlbumPressed(_ sender: Any) {
        let albumNameInputAlert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)
        
        albumNameInputAlert.addTextField { (textField) in
            textField.text = ""
        }
        
        albumNameInputAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak albumNameInputAlert] (_) in
            let textField = albumNameInputAlert?.textFields![0]
            if (textField?.text != nil && textField?.text != "") {
                AlbumRepository.saveAlbum(albumName: textField!.text!)
                self.albumNames.append(textField!.text!)
                self.tableView.reloadData()
            } else {
                let badNamealert = UIAlertController(title: "Album name cannot be blank!", message: nil, preferredStyle: .alert)
                badNamealert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in })
                self.present(badNamealert, animated: true)
            }
            
        }))
        
        self.present(albumNameInputAlert, animated: true, completion: nil)
    }
}
