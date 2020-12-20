//
//  CollectionViewCell.swift
//  Sample-flicker-MVVM
//
//  Created by Babak Afsheh on 12/20/20.
//


import UIKit
import Kingfisher
class SearchViewCell: UICollectionViewCell {
    @IBOutlet var photoImageView: UIImageView?

    var photosValue: PhotosModel? {
        didSet {
            guard let feeds = photosValue else {
                return
            }

            guard let url = URL(string: feeds.flickrImageURL() ?? "") else {
                return
            }
            photoImageView?.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholderImage"),
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.photoImageView?.contentMode =   UIView.ContentMode.scaleAspectFit
    }
}
