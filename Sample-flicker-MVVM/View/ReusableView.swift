//
//  ReusableView.swift
//  SampleFlicker-MVVm
//
//  Created by Babak Afsheh on 12/18/20.
//

import UIKit

protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: self) + "Identifier"
    }
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}


extension UICollectionViewCell: ReusableView { }
extension UITableViewCell: ReusableView { }
