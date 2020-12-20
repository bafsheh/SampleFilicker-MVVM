//
//  DetailViewCell.swift
//  Sample-flicker-MVVM
//
//  Created by Babak Afsheh on 12/20/20.
//

import UIKit

class DetailViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var photoImageView: UIImageView?

    var dataValue: DetailModel? {
        didSet {
            guard let data = dataValue else {
                return
            }
            titleLabel?.text = data.title
            if let imageUrl = data.description
            , let url = URL(string: imageUrl) {
                self.photoImageView?.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "placeholderImage"),
                    options: [
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ])
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.photoImageView?.contentMode =   UIView.ContentMode.scaleAspectFit
    }
}
