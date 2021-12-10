//
//  ImageDisplayViewController.swift
//  Site Manager
//
//  Created by Samuel Wong on 9/12/21.
//

import UIKit

class ImageDisplayViewController: UIViewController {

    var image: UIImage!
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        let scrollView = UIScrollView(frame: self.view.frame)
        scrollView.delegate = self
        scrollView.maximumZoomScale = 3
        
        imageView = UIImageView(frame: self.view.frame)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        scrollView.addSubViewWithSameSize(subview: imageView)
        self.view.addSubViewWithSameSize(subview: scrollView)
    }

}

//MARK: Scroll View Delegate
extension ImageDisplayViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
