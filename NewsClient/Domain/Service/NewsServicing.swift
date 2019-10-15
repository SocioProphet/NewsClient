//
//  NewsServicing.swift
//  NewsClient
//
//  Created by Taras Didukh on 14.10.2019.
//  Copyright © 2019 Taras Didukh. All rights reserved.
//

import Foundation

protocol NewsServicing {
    func fetchNews(params: NewsParameters, completionHandler: @escaping (Result<News, NetworkError>) -> Void)
}
