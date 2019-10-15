//
//  NewsParameters.swift
//  NewsClient
//
//  Created by Taras Didukh on 14.10.2019.
//  Copyright © 2019 Taras Didukh. All rights reserved.
//

import Foundation
struct NewsParameters {
    let query: String
    let page: Int
    let pageSize: Int
    let filter: FilterType
    
    init(query: String = "", page: Int = 1, pageSize: Int = 10, filter: FilterType = .all) {
        self.query = query
        self.page = page
        self.pageSize = pageSize
        self.filter = filter
    }
}
