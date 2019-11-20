//
//  ViewController.swift
//  secret-photo-album
//
//  Created by Zach Romano on 11/3/19.
//  Copyright © 2019 Zach Romano. All rights reserved.
//

import UIKit
import Photos

class AlbumController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let photoNames = [
        "arch", "bean", "breck", "coronado", "default", "grandCanyon",
        "hooverDam", "jhu", "pikePlace", "santaMonica", "whiteHouse"
    ]
    
    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPhotos()
    }
    
    func getPhotos() {
        
        for name in photoNames {
            imageArray.append(UIImage(named: name)!)
        }
        
//        let imgManager = PHImageManager.default()
//
//        let requestOptions = PHImageRequestOptions()
//        requestOptions.isSynchronous = true
//        requestOptions.deliveryMode = .opportunistic
//
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//
//        let fetchResult : PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
//
//        if fetchResult.count > 0 {
//            for i in 0..<fetchResult.count {
//                imgManager.requestImage(for: fetchResult.object(at: i), targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions, resultHandler:
//                    {
//                        image, error in
//
//                        self.imageArray.append(image!)
//                    }
//                )
//            }
//        } else {
//            print("you have no photos")
//            self.collectionView.reloadData()
//        }
//
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showPhotoSegue") {
            let photoView: PhotoController = segue.destination as! PhotoController
            let indexPath: NSIndexPath = self.collectionView.indexPath(for: sender as! UICollectionViewCell)! as NSIndexPath
            photoView.viewPhotoAtIndex = indexPath.item
            photoView.imageArray = self.imageArray
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        
        imageView.image = imageArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideLength = (collectionView.frame.width / 3) - 1
        
        return CGSize(width: sideLength, height: sideLength)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

