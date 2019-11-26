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
    
    @IBOutlet weak var albumTitle: UINavigationItem!
    
    var albumName: String = "Photo Album"
    
    var imageArray = [UIImage]()
    var imageDataArray = [ImageName]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumTitle.title = albumName
        getPhotos()
    }
    
    func getPhotos() {
        let imageNames = ImageNameRepository.getAllImageNamesByAlbum(albumName: self.albumName)
        for imageName in imageNames {
            
            if imageName.imageUrl != nil {
                if let imageFromFile = self.loadImageFromDiskWith(fileName: imageName.imageUrl!) {
                    imageArray.append(imageFromFile)
                    imageDataArray.append(imageName)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showPhotoSegue") {
            let photoView: PhotoController = segue.destination as! PhotoController
            let indexPath: NSIndexPath = self.collectionView.indexPath(for: sender as! UICollectionViewCell)! as NSIndexPath
            photoView.viewPhotoAtIndex = indexPath.item
            photoView.imageArray = self.imageArray
            photoView.imageDataArray = self.imageDataArray
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
    @IBAction func addPhotoFromCamera(_ sender: Any) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                self.getPhotoFromCamera()
            } else {
                self.alertPermissionRequired(resourceNeedingAccess: "Camera")
            }
        }
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    self.getPhotoFromLibrary()
                } else {
                    self.alertPermissionRequired(resourceNeedingAccess: "Photos")
                }
            })
        } else if photos == .authorized {
            self.getPhotoFromLibrary()
        }
    }
    
    func getPhotoFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            DispatchQueue.main.async {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self;
                imagePicker.sourceType = .photoLibrary
                imagePicker.mediaTypes = ["public.image", "public.movie"]
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func getPhotoFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            DispatchQueue.main.async {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self;
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = ["public.image", "public.movie"]
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    func alertPermissionRequired(resourceNeedingAccess: String) {
        let title = "Access Denied"
        let message = "Access to " + resourceNeedingAccess + " needs to be allowed."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alert, animated: true)
    }
    
    func saveImage(imageName: String, image: UIImage) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
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
    
}

extension AlbumController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage
        
        let imageName: String = UUID.init().uuidString
        let videoName: String = UUID.init().uuidString + ".mp4"
        
        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL]as? NSURL {
            do {
                let asset = AVURLAsset(url: videoURL as URL , options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                newImage = UIImage(cgImage: cgImage)
                
                let videoData = NSData(contentsOf: videoURL as URL)
                let path = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
                let newPath = path.appendingPathComponent(videoName)
                do {
                    try videoData?.write(to: newPath)
                } catch {
                    print(error)
                }
                    
                let newImageInfo = ImageNameRepository.saveVideo(albumName: self.albumName, thumbnailUrl: imageName, videoUrl: videoName)
                imageArray.append(newImage)
                self.imageDataArray.append(newImageInfo)
                self.saveImage(imageName: imageName, image: newImage)
            } catch let error {
                print("*** Error generating thumbnail: \(error.localizedDescription)")
                dismiss(animated: true)
                return
            }
        } else if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
            let newImageInfo = ImageNameRepository.saveImage(albumName: self.albumName, imageUrl: imageName)
            imageArray.append(newImage)
            self.imageDataArray.append(newImageInfo)
            self.saveImage(imageName: imageName, image: newImage)
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
            let newImageInfo = ImageNameRepository.saveImage(albumName: self.albumName, imageUrl: imageName)
            imageArray.append(newImage)
            self.imageDataArray.append(newImageInfo)
            self.saveImage(imageName: imageName, image: newImage)
        } else {
            dismiss(animated: true)
            return
        }

        
        dismiss(animated: true)
        collectionView.reloadData()
    }
}
