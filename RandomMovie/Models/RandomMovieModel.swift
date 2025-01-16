//
//  RandomMovieModel.swift
//  RandomMovie
//
//  Created by Семён Беляков on 09.01.2025.
//

import Foundation

// MARK: - RandomMovieModel

struct RandomMovieModel: Codable {
    let id: Int?
    let name: String?
    let alternativeName: String?
    let enName: String?
    let type: String?
    let typeNumber: Int?
    let year: Int?
    let description: String?
    let shortDescription: String?
    let slogan: String?
    let status: String?
    let rating: Rating?
    let votes: Votes?
    let movieLength: Int?
    let totalSeriesLength: Int?
    let seriesLength: Int?
    let ratingMpaa: String?
    let ageRating: Int?
    let genres: [Genre]?
    let countries: [Country]?
    let persons: [Person]?
    let premiere: Premiere?
    let top10: Int?
    let top250: Int?
    let isSeries: Bool?
    let ticketsOnSale: Bool?
    let lists: [String]?
    let createdAt: String?
    let updatedAt: String?
    let externalId: ExternalID?
    let facts: [String]?
    let names: [Name]?
    let poster: Poster?
    let productionCompanies: [String]?
    let fees: Fees?
    let budget: Budget?
    let backdrop: Backdrop?
    let logo: Logo?
    let watchability: Watchability?
    let videos: Videos?
    let deletedAt: String?
    let technology: Technology?
    let seasonsInfo: [String]?
    let sequelsAndPrequels: [String]?
    let similarMovies: [String]?
    let networks: [String]?
}

// MARK: - Backdrop
struct Backdrop: Codable {
    let url: String?
    let previewUrl: String?
}

// MARK: - Budget
struct Budget: Codable {
    let value: Int?
    let currency: String?
}

// MARK: - Country
struct Country: Codable {
    let name: String?
}

// MARK: - ExternalID
struct ExternalID: Codable {
    let kpHD: String?
    let imdb: String?
    let tmdb: Int?
}

// MARK: - Fees
struct Fees: Codable {
    let world: [String: String]?
    let russia: [String: String]?
    let usa: [String: String]?
}

// MARK: - Genre
struct Genre: Codable {
    let name: String?
}

// MARK: - Logo
struct Logo: Codable {
    let url: String?
    let previewUrl: String?
}

// MARK: - Name
struct Name: Codable {
    let name: String?
}

// MARK: - Person
struct Person: Codable {
    let id: Int?
    let photo: String?
    let name: String?
    let enName: String?
    let description: String?
    let profession: String?
    let enProfession: String?
}

// MARK: - Poster
struct Poster: Codable {
    let url: String?
    let previewUrl: String?
}

// MARK: - Premiere
struct Premiere: Codable {
    let world: String?
    let russia: String?
    let digital: String?
    let cinema: String?
    let bluray: String?
    let dvd: String?
}

// MARK: - Rating
struct Rating: Codable {
    let kp: Double?
    let imdb: Double?
    let filmCritics: Double?
    let russianFilmCritics: Double?
    let await: Double?
}

// MARK: - Technology
struct Technology: Codable {
    let hasImax: Bool?
    let has3D: Bool?
}

// MARK: - Votes
struct Votes: Codable {
    let kp: Int?
    let imdb: Int?
    let filmCritics: Int?
    let russianFilmCritics: Int?
    let await: Int?
}

// MARK: - Videos
struct Videos: Codable {
    let trailers: [String]?
}

// MARK: - Watchability
struct Watchability: Codable {
    let items: [String]?
}

