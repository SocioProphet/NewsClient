//
//  Network.swift
//  NewsClient
//
//  Created by Taras Didukh on 14.10.2019.
//  Copyright © 2019 Taras Didukh. All rights reserved.
//

import Foundation
public final class Network: Networking {
    private let session: URLSession
    
    init() {
        // setup different configuration (timeout, etc)
        session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    func get<TResponse: Codable>(_ url: URL, completionHandler: @escaping (Result<TResponse, NetworkError>) -> Void) {
        session.dataTask(with: url) { data, response, error in
            if error != nil || data == nil {
                completionHandler(.failure(.clientError))
                return
            }
    
            do {
            let result = try JSONDecoder().decode(TResponse.self, from: data!)
                completionHandler(.success(result))
            } catch {
                completionHandler(.failure(.parseError))
            }
        }.resume()
    }
}
