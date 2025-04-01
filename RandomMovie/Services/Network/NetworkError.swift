//
//  NetworkError.swift
//  RandomMovie
//
//  Created by Семён Беляков on 09.01.2025.
//

import Foundation

enum NetworkError: Error {
    case decodingError(String)
    case invalidResponse(String)
    case unknownError(String)
}
