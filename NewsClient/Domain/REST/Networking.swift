//
//  Networking.swift
//  NewsClient
//
//  Created by Taras Didukh on 14.10.2019.
//  Copyright © 2019 Taras Didukh. All rights reserved.
//

import Foundation
protocol Networking {
    func get<TResponse: Codable>(_ url: URL, completionHandler: @escaping (Result<TResponse, NetworkError>) -> Void)
}
