//
//  AddString.swift
//  rtc_phone
//
//  Created by Андрей Королев on 12.05.2022.
//

import UIKit

extension StringTVC {
    func alertPlusString(name: String, placeholder: String, completionHandler: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: name, message: nil, preferredStyle: .alert)
        let alertOK = UIAlertAction(title: "OK", style: .default) { (action) in
            let tfText = alertController.textFields?.first
            guard let text = tfText?.text else {
                return
            }
            completionHandler(text)
        }
        
        alertController.addTextField() { (tf) in
            tf.placeholder = placeholder
        }
        
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel) {(_)in}
        
        alertController.addAction(alertOK)
        alertController.addAction(alertCancel)
        
        present(alertController, animated: true, completion: nil)
    }
}
