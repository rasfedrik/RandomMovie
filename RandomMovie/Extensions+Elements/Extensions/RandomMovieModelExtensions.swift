//
//  RandomMovieModelExtensions.swift
//  RandomMovie
//
//  Created by Семён Беляков on 14.04.2025.
//

import UIKit

extension MovieDetailsModel: Hashable {
    static func == (lhs: MovieDetailsModel, rhs: MovieDetailsModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension MovieDetailsModel.Person: Hashable, Equatable {
    static func == (lhs: MovieDetailsModel.Person, rhs: MovieDetailsModel.Person) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
