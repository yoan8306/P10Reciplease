//
//  UIViewController_Alert.swift
//  Reciplease
//
//  Created by Yoan on 02/05/2022.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlertError (alertTitle title: String = "Error", alertMessage message: String,
                       buttonTitle titleButton: String = "Ok",
                       alertStyle style: UIAlertAction.Style = .cancel ) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: titleButton, style: style, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
    func presentAlertSuccess (alertTitle title: String = "Success", alertMessage message: String,
                              buttonTitle titleButton: String = "Ok",
                              alertStyle style: UIAlertAction.Style = .cancel ) {
               let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
               let action = UIAlertAction(title: titleButton, style: style, handler: nil)
               alertVC.addAction(action)
               present(alertVC, animated: true, completion: nil)
           }
}
