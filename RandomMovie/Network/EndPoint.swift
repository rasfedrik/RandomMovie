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
        
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "notNullFields", value: "name"),
            URLQueryItem(name: "notNullFields", value: "id")
        ]
        
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
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "X-API-KEY": "YHE67YR-2CEM9X3-JHKC6SR-9VWT8YB"
        ]
        
        print(url)
        return request
    }
    
}

extension EndPoint {
    
    static var random: Self {
        return EndPoint(path: "movie/random")
    }
    
    static var id: Self {
        return EndPoint(path: "movie/5136049")
    }
    
    static var search: Self {
        return EndPoint(path: "movie/search")
    }
    
}
