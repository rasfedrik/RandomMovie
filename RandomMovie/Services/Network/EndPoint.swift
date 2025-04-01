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
    
    enum ContentType: String {
        case movie = "movie/"
    }
    
    private let apiVersion = "/v1.4/"
    private var path: String
    
    private var additionalQueryItems: [URLQueryItem]?
    
    private var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.kinopoisk.dev"
        components.path = apiVersion + ContentType.movie.rawValue + path
        
        let currentYear = Calendar.current.component(.year, from: Date())
        
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "notNullFields", value: "id"),
            URLQueryItem(name: "notNullFields", value: "poster.url"),
            URLQueryItem(name: "rating.kp", value: "1.0-10.0"),
            URLQueryItem(name: "year", value: "1960-\(currentYear)")
        ]
        
        if let additionalQueryItems = additionalQueryItems {
            for item in additionalQueryItems {
                queryItems.removeAll(where: {$0.name == item.name})
                queryItems.append(item)
            }
        }
        
        if components.queryItems == nil {
            components.queryItems = queryItems
        } else {
            components.queryItems?.append(contentsOf: queryItems)
        }
        
        if let urlString = components.url?.absoluteString {
            let finalURLString = urlString.replacingOccurrences(of: "%25", with: "%")
            if let finalURL = URL(string: finalURLString) {
//                print("Final URL: \(finalURL)")
                return finalURL
            }
        }
        
        return self.url
    }
    
    var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 20
        
        var headerFields = ApiConstants.apiKey
        headerFields["accept"] = "application/json"
        request.allHTTPHeaderFields = headerFields
        return request
    }
    
}

extension EndPoint {
    static func random() -> Self {
        return EndPoint(path: TypeEndPoint.random.rawValue)
    }
    
    static func movieByID(_ id: Int?) -> Self {
        
        return EndPoint(path: "\(id ?? 0)")
    }
    
    static func random(with filters: FiltersModel? = nil, additionalQueryItems: [URLQueryItem]? = nil) -> Self {
        
        var queryItems = [URLQueryItem]()
        
        if let genres = filters?.genres?["genres.name"] {
            for genre in genres where !genre.isEmpty {
                let encodedValue = "%2B\(genre)"
                queryItems.append(URLQueryItem(name: "genres.name", value: encodedValue))
            }
        }
        
        if let ratingKp = filters?.ratingKp, let nameCategory = ratingKp.nameCategory {
            queryItems.removeAll(where: { $0.name == "rating.kp" })
            let minValue = String(ratingKp.minValue ?? 1)
            
            if let maxValue = ratingKp.maxValue {
                let encodedValue = "\(minValue)-\(maxValue)"
                queryItems.append(URLQueryItem(name: nameCategory, value: encodedValue))
            } else {
                queryItems.append(URLQueryItem(name: nameCategory, value: minValue))
            }
        }
        
        if let years = filters?.years, let nameCategory = years.nameCategory {
            let minValue = String(Int(years.minValue ?? 0))
            
            if let maxValue = years.maxValue, maxValue != 0 {
                let encodedValue = "\(minValue)-\(Int(maxValue))"
                queryItems.append(URLQueryItem(name: nameCategory, value: encodedValue))
            } else {
                queryItems.append(URLQueryItem(name: nameCategory, value: minValue))
            }
        }
        
        if let additionalQueryItems = additionalQueryItems {
            queryItems.append(contentsOf: additionalQueryItems)
            print(additionalQueryItems)
        }
        
        return EndPoint(
            path: TypeEndPoint.random.rawValue,
            additionalQueryItems: queryItems
        )
    }
}

