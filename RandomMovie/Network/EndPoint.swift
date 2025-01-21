//
//  EndPoint.swift
//  RandomMovie
//
//  Created by Семён Беляков on 09.01.2025.
//

import Foundation

struct EndPoint {
    
    public var path: String
}

extension EndPoint {
    
    private var url: URL {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.kinopoisk.dev"
        components.path = "/v1.4/" + path
        
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "notNullFields", value: "id"),
//            URLQueryItem(name: "notNullFields", value: "name")
        ]
        
        if path.contains("movie/search") {
            queryItems.append(URLQueryItem(name: "page", value: "1"))
            queryItems.append(URLQueryItem(name: "limit", value: "3"))
        }
        
        if var existingQueryItems = components.queryItems {
            existingQueryItems.append(contentsOf: queryItems)
            components.queryItems = existingQueryItems
        } else {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        
        return url
    }
    
    var request: URLRequest {
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 20
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "X-API-KEY": "YHE67YR-2CEM9X3-JHKC6SR-9VWT8YB"
        ]
        
        return request
    }
    
}

extension EndPoint {
    
    static var random: Self {
        return EndPoint(path: "movie/random")
    }
    
    static var search: Self {
        return EndPoint(path: "movie/search")
    }
    
}
