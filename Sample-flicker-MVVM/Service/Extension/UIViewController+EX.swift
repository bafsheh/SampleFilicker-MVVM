//
//  UIViewController+EX.swift
//  SampleFlicker-MVVm
//
//  Created by Babak Afsheh on 12/18/20.
//

import UIKit

extension UIViewController {
    // Returns the error message
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) -> Void in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
