//
//  MovieDetailsModel.swift
//  RandomMovie
//
//  Created by Семён Беляков on 17.04.2025.
//

import UIKit

struct MovieDetailsModel: Codable {
    let id: Int?
    let name: String?
    let alternativeName: String?
    let rating: Rating?
    let year: Int?
    let status: String?
    let genres: [Genre]?
    let persons: [Person]?
    let poster: Poster?
    let description: String?
    var isFavorite: Bool?
    
    var posterData: Data?
    var personPhotoData: Data?
    
    func getImage(data: Data?) -> UIImage? {
        guard let data = data else { return nil }
        return UIImage(data: data)
    }
    
    // MARK: - Poster
    struct Poster: Codable {
        let url: String?
        let previewUrl: String?
    }
    
    // MARK: - Rating
    struct Rating: Codable {
        let kp: Double?
        let imdb: Double?
        let filmCritics: Double?
        let russianFilmCritics: Double?
    }
    
    // MARK: - Genre
    struct Genre: Codable {
        let name: String?
    }
    
    // MARK: - Person
    struct Person: Codable {
        let id: Int?
        let photo: String?
        let name: String?
        let description: String?
        let profession: String?
    }
    
}
