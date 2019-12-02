//
//  AlbumSettingsController.swift
//  secret-photo
//
//  Created by Zach Romano on 11/28/19.
//  Copyright © 2019 Zach Romano. All rights reserved.
//

import UIKit

class AlbumSettingsController: UIViewController {
    
    @IBOutlet weak var albumNameTextField: UITextField!
    var albumName: String = "Album Name"

    override func viewDidLoad() {
        super.viewDidLoad()

        albumNameTextField.text = albumName
    }
    
    @IBAction func saveAlbumSettingsPressed(_ sender: Any) {
        // if blank ablum name:
        if (albumNameTextField.text == nil || albumNameTextField.text == "") {
            let badNamealert = UIAlertController(title: "Album name cannot be blank!", message: nil, preferredStyle: .alert)
            badNamealert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in })
            self.present(badNamealert, animated: true)
            return
        }
        
        _ = ImageNameRepository.updateAlbumNameForImagesInAlbum(oldAlbumName: albumName, newAlbumName: albumNameTextField.text!)
        _ = AlbumRepository.updateAlbumSettings(oldAlbumName: albumName, newAlbumName: albumNameTextField.text!)
        
        // pop view to album page
        _ = navigationController?.popViewController(animated: true)
    }
}
