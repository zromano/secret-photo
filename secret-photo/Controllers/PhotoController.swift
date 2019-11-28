//
//  ViewPhoto.swift
//  secret-photo-album
//
//  Created by Zach Romano on 11/4/19.
//  Copyright © 2019 Zach Romano. All rights reserved.
//

import UIKit
import AVKit

class PhotoController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var imageArray = [UIImage]()
    var imageDataArray = [ImageName]()
    
    var viewPhotoAtIndex: Int = 0

    override func viewWillAppear(_ animated: Bool) {
        // populate the images and make them scrollable
        scrollView.frame = view.frame
        for imgIndex in 0..<imageArray.count {
            let imgView = UIImageView()
            imgView.image = imageArray[imgIndex]
            imgView.contentMode = .scaleAspectFit
            let xPosition = self.view.frame.width * CGFloat(imgIndex)
            imgView.frame = CGRect(x: xPosition, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            scrollView.contentSize.width = scrollView.frame.width * CGFloat(imgIndex + 1)
            scrollView.addSubview(imgView)
            
            if (imageDataArray[imgIndex].isVideo) {
                let image = UIImage(named: "playButton")
                let button = UIButton()
                let playButtonXPos = imgView.frame.minX + (imgView.frame.width / 2) - 50
                let playButtonYPos = imgView.frame.minY + (imgView.frame.height / 2) - 50
                button.frame = CGRect(x: playButtonXPos, y: playButtonYPos, width: 100, height: 100)
                button.setBackgroundImage(image, for: UIControl.State.normal)
                button.addTarget(self, action:#selector(self.imageButtonTapped(_:)), for: .touchUpInside)
                
                scrollView.addSubview(button)
                
            }
        }
        // show the correct image
        scrollToPage(page: viewPhotoAtIndex, animated: true)

    }
    
    func generateVideoUrl(fileName: String) -> URL? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            return URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
        }
        return nil
    }
    
    func scrollToPage(page: Int, animated: Bool) {
        if (page > viewPhotoAtIndex || page < 0) {
            return
        }
        // scroll to page won't work without a height
        scrollView.contentSize.height = imageArray[page].size.height
        var frame: CGRect = self.scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        scrollView.scrollRectToVisible(frame, animated: animated)
        // set it the content height back to 0
        scrollView.contentSize.height = 0
    }
    
    @objc func imageButtonTapped(_ sender:UIButton!)
    {
        let page: Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width);
        print(page)

        let videoName: String = imageDataArray[page].videoUrl!
        if let url = self.generateVideoUrl(fileName: videoName){
            let player = AVPlayer(url: url)
            let vc = AVPlayerViewController()
            vc.player = player
            
            present(vc, animated: true) {
                vc.player?.play()
            }
        }
        
    }
    
    @IBAction func deletePhotoButtonTapped(_ sender: Any) {
        let imageInfo = imageDataArray[getCurrentPage()]
        
        // remove photo from files
        _ = MediaHandler.deleteMediaFile(fileName: imageInfo.imageUrl!)
        
        // possibly remove video
        if (imageInfo.isVideo) {
            _ = MediaHandler.deleteMediaFile(fileName: imageInfo.videoUrl!)
        }
        
        // remove ImageName from CoreData
        _ = ImageNameRepository.deleteImageInfo(imageName: imageInfo.imageUrl!)
        
        // pop view to album page
        _ = navigationController?.popViewController(animated: true)
    }
    
    func getCurrentPage() -> Int {
        return Int(scrollView.contentOffset.x / scrollView.frame.size.width);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
