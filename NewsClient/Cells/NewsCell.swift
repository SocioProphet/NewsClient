//
//  NewsCell.swift
//  NewsClient
//
//  Created by Taras Didukh on 14.10.2019.
//  Copyright © 2019 Taras Didukh. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    static var reusableIdentifier = "NewsCell"
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbAuthor: UILabel!
    @IBOutlet weak var btnSource: UIButton!
    @IBOutlet weak var activityImage: UIActivityIndicatorView!
    
    private var _url: String?
    var url: String? {
        set {
            guard newValue != url else { return }
            _url = newValue
            img.image = nil
            imageLoading = true
            DispatchQueue.global().async { [weak self] in
                if let link = newValue, let url = URL(string: link), let data = try? Data(contentsOf: url), self?.url == newValue, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.img.image = image
                            self?.imageLoading = false
                        }
                } else {
                    self?.imageLoading = false
                }
            }
        }
        get {
            return _url
        }
    }
    
    var imageLoading: Bool {
        set {
            DispatchQueue.main.async {
                self.img.isHidden = newValue
                newValue ? self.activityImage.startAnimating() : self.activityImage.stopAnimating()
            }
        }
        get {
            return self.img.isHidden
        }
    }
}
