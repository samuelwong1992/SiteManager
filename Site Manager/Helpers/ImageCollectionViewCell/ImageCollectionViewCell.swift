//
//  ImageCollectionViewCell.swift
//  Site Manager
//
//  Created by Samuel Wong on 16/2/21.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    static var kNib: UINib {
        return UINib(nibName: StoryboardConstants.Nib.ImageCollectionViewCell.identifier, bundle: nil)
    }
    static let kReuseIdentifier = StoryboardConstants.Nib.ImageCollectionViewCell.identifier
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
}
