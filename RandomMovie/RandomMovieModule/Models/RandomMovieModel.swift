//
//  RandomMovieModel.swift
//  RandomMovie
//
//  Created by Семён Беляков on 19.01.2025.
//


import Foundation

struct RandomMovieModel: Codable, MoviewModelProtocol {
    
    let id: Int?
    let name: String?
    let alternativeName: String?
    let description: String?
    let type: String?
    let year: Int?
    let status: String?
    let rating: Rating?
    let votes: Votes?
    let movieLength: Int?
    let seriesLength: Int?
    let totalSeriesLength: Int?
    let genres: [Genre]?
    let countries: [Country]?
    let premiere: Premiere?
    let poster: Poster?
    let watchability: Watchability?
    let persons: [Person]?
    let seasonsInfo: [SeasonInfo]?
    let names: [Name]?
    let externalId: ExternalId?
    let enName: String?
    let typeNumber: Int?
    let slogan: String?
    let ageRating: Int?
    let top250: Int?
    let isSeries: Bool?
    let ticketsOnSale: Bool?
    let lists: [String]?
    let createdAt: String?
    let updatedAt: String?
    let productionCompanies: [ProductionCompany]?

    struct Rating: Codable {
        let kp: Double?
        let imdb: Double?
        let filmCritics: Double?
        let russianFilmCritics: Double?
    }
    
    struct Votes: Codable {
        let kp: Int?
        let imdb: Int?
        let filmCritics: Int?
        let russianFilmCritics: Int?
    }
    
    struct Genre: Codable {
        let name: String?
    }
    
    // MARK: - Name
    struct Name: Codable {
        let name: String?
    }
    
    struct Country: Codable {
        let name: String?
    }
    
    struct Premiere: Codable {
        let russia: String?
    }
    
    struct Poster: Codable {
        let url: String?
        let previewUrl: String?
    }
    
    struct Watchability: Codable {
        let items: [WatchItem]?
    }
    
    struct WatchItem: Codable {
        let name: String?
        let logo: Logo?
        let url: String?
    }
    
    struct Logo: Codable {
        let url: String?
        let previewUrl: String?
    }
    
    struct Person: Codable {
        let id: Int?
        let photo: String?
        let name: String?
        let description: String?
        let profession: String?
    }
    
    struct ProductionCompany: Codable {
            let name: String?
            let url: String?
            let previewUrl: String?
        }
    
    struct SeasonInfo: Codable {
        let number: Int?
        let episodesCount: Int?
    }
    
    struct ExternalId: Codable {
        let kpHD: String?
        let imdb: String?
        let tmdb: Int?
    }
}

