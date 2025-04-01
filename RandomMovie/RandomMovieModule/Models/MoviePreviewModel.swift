//
//  MoviePreviewModel.swift
//  RandomMovie
//
//  Created by Семён Беляков on 26.01.2025.
//

import UIKit

struct MoviePreviewModel: Codable, MoviewModelProtocol {
    
    let id: Int?
    let name: String?
    let alternativeName: String?
    let poster: Poster?
    let rating: Rating?
    var posterData: Data?
    
//    init(id: Int?, name: String?, alternativeName: String?, posterData: UIImage?, rating: Rating?, poster: Poster?) {
//        self.id = id
//        self.name = name
//        self.alternativeName = alternativeName
//        self.posterData = posterData?.jpegData(compressionQuality: 0.8)
//        self.rating = rating
//        self.poster = poster
//    }
    
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
