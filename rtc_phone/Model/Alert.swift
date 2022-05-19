//
//  Alert.swift
//  rtc_route
//
//  Created by Андрей Королев on 01.05.2022.
//

import Foundation
import UIKit

extension UIViewController {
    func alertError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertOK = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(alertOK)
        
        present(alertController, animated: true, completion: nil)
    }
}
