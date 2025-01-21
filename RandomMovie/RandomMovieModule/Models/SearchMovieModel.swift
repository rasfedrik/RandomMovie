//
//  SearchMovieModel.swift
//  RandomMovie
//
//  Created by Семён Беляков on 16.01.2025.
//

import Foundation


// MARK: - SearchMovieModel
struct SearchMovieModel: Codable, MoviewModelProtocol {
    let docs: [Doc]?
    let total, limit, page, pages: Int?
    
    
    // MARK: - Doc
    struct Doc: Codable {
        let id: Int?
        let name, alternativeName, enName, type: String?
        let year: Int?
        let description, shortDescription: String?
        let movieLength: Int?
        let isSeries, ticketsOnSale: Bool?
        let totalSeriesLength, seriesLength: Int?
        let ratingMPAA: String?
        let ageRating: Int?
        let top10: Int?
        let top250, typeNumber: Int?
        //    let status: Int?
        let releaseYears: [ReleaseYears?]?
    }
    
    struct ReleaseYears: Codable {
        let releaseYear: Int?
    }
}
