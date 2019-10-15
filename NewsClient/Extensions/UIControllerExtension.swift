//
//  UIControllerExtensions.swift
//  NewsClient
//
//  Created by Taras Didukh on 12.10.2019.
//  Copyright © 2019 Taras Didukh. All rights reserved.
//

import UIKit


extension UIViewController {
    func displayAlert(key: String, title: String = "", message: String = "")
    {
        DispatchQueue.main.async {
            if !UserDefaults.standard.bool(forKey: key) {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    alert.dismiss(animated: true, completion: nil)
                })
                alert.addAction(UIAlertAction(title: "Don't show again", style: .destructive) { _ in
                    UserDefaults.standard.set(true, forKey: key)
                    //alert.dismiss(animated: true, completion: nil)
                })
                //self.dismiss(animated: false, completion: nil)
                self.present(alert, animated: false, completion: nil)
            }
        }
        
    }
}
