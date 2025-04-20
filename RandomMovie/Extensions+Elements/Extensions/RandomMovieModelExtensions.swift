//
//  RandomMovieModelExtensions.swift
//  RandomMovie
//
//  Created by Семён Беляков on 14.04.2025.
//

import Foundation

extension MovieDetailsModel: Hashable {
    static func == (lhs: MovieDetailsModel, rhs: MovieDetailsModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
