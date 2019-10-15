//
//  NewsService.swift
//  NewsClient
//
//  Created by Taras Didukh on 14.10.2019.
//  Copyright © 2019 Taras Didukh. All rights reserved.
//

import Foundation

public final class NewsService: NewsServicing {
    let network: Networking
    
    init(network: Networking) {
        self.network = network
    }
    
    func fetchNews(params: NewsParameters, completionHandler: @escaping (Result<News, NetworkError>) -> Void)
    {
        
        var link = "\(Constants.newsApiUrl)top-headlines?page=\(params.page)&pageSize=\(params.pageSize)&sortBy=publishedAt&apiKey=\(Constants.newsApiKey)&"
        let query = params.query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        if query.isEmpty {
            link += "\(FilterType.country.rawValue)=ua"
        } else if params.filter == .all {
            link += "q=\(query)"
        } else if params.filter == .country {
            link += "\(FilterType.country.rawValue)=\(Iso3166_1a2.all.first(where: {$0.country.lowercased().contains(params.query.lowercased())})?.rawValue.lowercased() ?? "ua")"
        } else {
            link += "\(params.filter.rawValue)=\(query)"
        }
        print("-----------------------\n\(link)\n-----------------------\n")
        if let url = URL(string: link) {
            self.network.get(url, completionHandler: completionHandler)
        }
    }
}
