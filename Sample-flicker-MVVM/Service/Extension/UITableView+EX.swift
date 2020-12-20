//
//  UITableView+EX.swift
//  Sample-flicker-MVVM
//
//  Created by Babak Afsheh on 12/20/20.
//

import UIKit

extension UITableView {

    func register<T: UITableViewCell>(_: T.Type) {

        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }

        return cell
    }
}
