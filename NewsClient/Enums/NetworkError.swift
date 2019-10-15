//
//  NetworkError.swift
//  NewsClient
//
//  Created by Taras Didukh on 14.10.2019.
//  Copyright © 2019 Taras Didukh. All rights reserved.
//

enum NetworkError: Error {
    case clientError,
    serverError,
    parseError,
    unexpectedError
}
