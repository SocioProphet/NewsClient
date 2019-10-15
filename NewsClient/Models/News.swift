//
//  News.swift
//  NewsClient
//
//  Created by Taras Didukh on 14.10.2019.
//  Copyright © 2019 Taras Didukh. All rights reserved.
//

import Foundation
struct News: Codable {
    var status: String?
    var totalResults: Int?
    var articles: [Article]?
    
    var code: String?
    var message: String?
}
