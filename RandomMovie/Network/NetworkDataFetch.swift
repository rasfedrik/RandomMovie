//
//  NetworkDataFetch.swift
//  RandomMovie
//
//  Created by Семён Беляков on 09.01.2025.
//

import Foundation

protocol NetworkDataFetchProtocol {
    func fetchData<T:Codable> (endPoint: EndPoint,
                               expecting: T.Type,
                               completion: @escaping (Result<T, NetworkError>) -> Void)
}

final class NetworkDataFetch: NetworkDataFetchProtocol {
    static let share = NetworkDataFetch()
    
    func fetchData<T:Codable> (endPoint: EndPoint,
                               expecting: T.Type,
                               completion: @escaping (Result<T, NetworkError>) -> Void)
    {
        URLSession.shared.dataTask(with: endPoint.request) { data, response, error in
            
            guard
                let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode),
                 
                let data = data else {
                
                if let error = error {
                    completion(.failure(.unknownError(error.localizedDescription)))
                } else {
                    completion(.failure(.invalidResponse("Invalid HTTP response or no data")))
                }
                
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                if let jsonString = String(data: data, encoding: .utf8) {
//                    print("Полученный JSON:\n\n\(jsonString)\n\n")
//                }
                let result = try decoder.decode(T.self, from: data)
                
                completion(.success(result))
                
            } catch let DecodingError.dataCorrupted(context) {
                print("Data corrupted: \(context.debugDescription)")
                completion(.failure(.decodingError(context.debugDescription)))
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found: \(context.debugDescription)")
                completion(.failure(.decodingError("Key '\(key)' not found: \(context.debugDescription)")))
            } catch let DecodingError.typeMismatch(type, context) {
                print("Type '\(type)' mismatch: \(context.debugDescription)")
                completion(.failure(.decodingError("Type '\(type)' mismatch: \(context.debugDescription)")))
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found: \(context.debugDescription)")
                completion(.failure(.decodingError("Value '\(value)' not found: \(context.debugDescription)")))
            } catch {
                print("Error: \(error.localizedDescription)")
                completion(.failure(.unknownError(error.localizedDescription)))
            }
        }.resume()
    }
}
