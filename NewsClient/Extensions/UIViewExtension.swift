//
//  UIViewExtensions.swift
//  NewsClient
//
//  Created by Taras Didukh on 12.10.2019.
//  Copyright © 2019 Taras Didukh. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    func activityIndicator(_ show: Bool) {
        let tag = 800043
        if show {
            let indicator = UIActivityIndicatorView(style: .gray)
            let viewHeight = self.bounds.size.height
            let viewWidth = self.bounds.size.width
            indicator.center = CGPoint(x: viewWidth/2, y: viewHeight/3)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
    
    func emptyList(_ show: Bool, _ message: String) {
        let tag = 800045
        if show {
            guard (self.viewWithTag(tag) as? UILabel) == nil else { return }
            let viewHeight = self.bounds.size.height
            let viewWidth = self.bounds.size.width
            let label = UILabel(frame: CGRect(x: 0, y: viewHeight/4, width: viewWidth, height: 20))
            label.textColor = UIColor.black
            label.text = message
            label.textAlignment = NSTextAlignment.center
            label.font = UIFont(name: "HelveticaNeue", size: 16)
            label.tag = tag
            self.addSubview(label)
        } else {
            if let label = self.viewWithTag(tag) as? UILabel {
                label.removeFromSuperview()
            }
        }
    }
}
