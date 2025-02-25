//
//  EndPoint.swift
//  RandomMovie
//
//  Created by Семён Беляков on 09.01.2025.
//

import Foundation

struct EndPoint {
    
    enum TypeEndPoint: String {
        case random = "random"
    }
    
    enum ContemtType: String {
        case movie = "movie/"
    }
    
    private var id = "0"
    private let apiVersion = "/v1.4/"
    private var path: String
    
    public var filters: [String:String]?
    private var additionalQueryItems: [URLQueryItem]?
    
    
    private var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.kinopoisk.dev"
        components.path = apiVersion + ContemtType.movie.rawValue + path
        
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "notNullFields", value: "id"),
            URLQueryItem(name: "notNullFields", value: "poster.url")
        ]
        
        if let additionalQueryItems = additionalQueryItems {
            queryItems.append(contentsOf: additionalQueryItems)
        }
        
        //        if path.contains("movie/search") {
        //            queryItems.append(URLQueryItem(name: "page", value: "1"))
        //            queryItems.append(URLQueryItem(name: "limit", value: "3"))
        //        }
        
        //        if let filters = filters {
        //            for (name, value) in filters {
        //                queryItems.append(URLQueryItem(name: name, value: value))
        //            }
        //        }
        
        //        if var existingQueryItems = components.queryItems {
        //            existingQueryItems.append(contentsOf: queryItems)
        //            components.queryItems = existingQueryItems
        //        } else {
        //            components.queryItems = queryItems
        //        }
        
        components.queryItems = (components.queryItems ?? []) + queryItems
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        
        print(url)
        return url
    }
    
    
    var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 20
        
        var headerFields = Constants.apiKey
        headerFields["accept"] = "application/json"
        request.allHTTPHeaderFields = headerFields
        return request
    }
    
}

extension EndPoint {
    static func random() -> Self {
        return EndPoint(path: TypeEndPoint.random.rawValue)
    }
    
    static func details(with id: Int?) -> Self {
        return EndPoint(path: "\(id ?? 0)")
    }
    
//    static func details(withId: Int? = nil, additionalQueryItems: [URLQueryItem]? = nil) -> Self {
//        return EndPoint(
//            path: TypeEndPoint.random.rawValue,
//            additionalQueryItems:
//                [URLQueryItem(name: "id", value: "\(withId ?? 0)")]
//        )
//    }
}
