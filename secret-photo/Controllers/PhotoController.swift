//
//  ViewPhoto.swift
//  secret-photo-album
//
//  Created by Zach Romano on 11/4/19.
//  Copyright © 2019 Zach Romano. All rights reserved.
//

import UIKit

class PhotoController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var imageArray = [UIImage]()
    var viewPhotoAtIndex: Int = 0
    
    override func viewDidLoad() {
        // todo try with helloworld label
        
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
    
        override func viewWillAppear(_ animated: Bool) {
            // populate the images and make them scrollable
            scrollView.frame = view.frame
            for imgIndex in 0..<imageArray.count {
                let imgView = UIImageView()
                imgView.image = imageArray[imgIndex]
                imgView.contentMode = .scaleAspectFit
                let xPosition = self.view.frame.width * CGFloat(imgIndex)
                imgView.frame = CGRect(x: xPosition, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
                // set the width
                scrollView.contentSize.width = scrollView.frame.width * CGFloat(imgIndex + 1)
                scrollView.addSubview(imgView)
            }
            // show the correct image
            scrollToPage(page: viewPhotoAtIndex, animated: true)
    
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
