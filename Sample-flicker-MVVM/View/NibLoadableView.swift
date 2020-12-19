//
//  NibLoadableView.swift
//  SampleFlicker-MVVm
//
//  Created by Babak Afsheh on 12/18/20.
//

import UIKit

protocol NibLoadableView: class { }

extension NibLoadableView where Self: UIView {

    static var nibName: String {
        return String(describing: self)
    }

}

extension UITableViewCell: NibLoadableView { }
