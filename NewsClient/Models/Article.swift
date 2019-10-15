//
//  Article.swift
//  NewsClient
//
//  Created by Taras Didukh on 14.10.2019.
//  Copyright © 2019 Taras Didukh. All rights reserved.
//

struct Article: Codable {
    var source: Source?
    var author: String?
    var title: String?
    var description: String?
    var urlToImage: String?
    var url: String?
}
