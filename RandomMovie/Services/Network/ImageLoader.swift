//
//  ImageLoader.swift
//  RandomMovie
//
//  Created by Семён Беляков on 28.01.2025.
//

import Foundation

final class ImageLoader {
    static let share = ImageLoader()
    
    private init() {}
    
    private var imageDataCashe = NSCache<NSString, NSData>()
    
    func imageLoader(_ url: URL?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        
        guard let urlString = url else { return }
        
        let key = urlString.absoluteString as NSString
        if let imageData = imageDataCashe.object(forKey: key) {
            completion(.success(imageData as Data))
            return
        }
        
        let urlRequest = URLRequest(url: urlString)
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                return
            }
            
            guard let data = data else {
                if let error = error {
                    completion(.failure(.unknownError(error.localizedDescription)))
                } else {
                    completion(.failure(.invalidResponse("Invalid HTTP response or no data")))
                }
                return
            }
            
            let value = data as NSData
            self?.imageDataCashe.setObject(value, forKey: key)
            
            completion(.success(data))
        }
        task.resume()
    }
}
