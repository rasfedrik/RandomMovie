//
//  MoviePreviewModel.swift
//  RandomMovie
//
//  Created by Семён Беляков on 26.01.2025.
//

import UIKit

struct MoviePreviewModel: Codable {
    
    let id: Int?
    let name: String?
    let alternativeName: String?
    let poster: Poster?
    let rating: Rating?
    let year: Int?
    var posterData: Data?
    var isFavorite: Bool {
        return FavoriteService().isFavorite(movieId: id ?? 0)
    }
    
    func getPosterImage() -> UIImage? {
        guard let data = posterData else { return nil }
        return UIImage(data: data)
    }
    
    struct Poster: Codable {
        let url: String?
        let previewUrl: String?
    }
    
    struct Rating: Codable {
        let kp: Double?
        let imdb: Double?
        let filmCritics: Double?
        let russianFilmCritics: Double?
    }
}
