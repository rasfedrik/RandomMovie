//
//  FiltersModel.swift
//  RandomMovie
//
//  Created by Семён Беляков on 28.02.2025.
//

import Foundation

protocol FilterValueRangeProtocol {
    var nameCategory: String? { get set }
    var minValue: Float? { get set }
    var maxValue: Float? { get set }
}

struct FiltersModel {
    var years: RangeFiters? = RangeFiters()
    var ratingKp: RangeFiters? = RangeFiters()
    var genres: [String: Set<String>]?
    
    struct RangeFiters: FilterValueRangeProtocol {
        var nameCategory: String?
        var minValue: Float?
        var maxValue: Float?
    }
    
    mutating func clearFilters() {
        years = nil
        ratingKp = nil
        genres = nil
    }
    
    mutating private func removeGenre(_ type: String) {
        genres?["genres.name"]?.remove(type)
    }
    
    mutating private func insertGenre(_ type: String) {
        genres?["genres.name"]?.insert(type)
    }
    
    mutating func genresFilter(_ type: String) {
        if genres?["genres.name"] == nil {
           genres = ["genres.name": [type]]
        } else if let genres = genres?["genres.name"] {
            if !genres.isEmpty && genres.contains(type) {
                removeGenre(type)
            } else {
                insertGenre(type)
            }
        }
    }
}
