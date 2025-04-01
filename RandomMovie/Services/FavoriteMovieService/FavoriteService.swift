//
//  FavoriteService.swift
//  RandomMovie
//
//  Created by Семён Беляков on 27.03.2025.
//

import Foundation

protocol FavoriteServiceProtocol {
    func toggleFavorite(movieId: Int)
    func isFavorite(movieId: Int) -> Bool
    func getAllFavorites() -> [Int]
}

final class FavoriteService: FavoriteServiceProtocol {
    private let favoritesKey = "favoriteMovieIDs"
    
    func toggleFavorite(movieId: Int) {
        var favorites = getAllFavorites()
        if let index = favorites.firstIndex(of: movieId) {
            favorites.remove(at: index)
        } else {
            favorites.append(movieId)
        }
        UserDefaults.standard.set(favorites, forKey: favoritesKey)
    }
    
    func isFavorite(movieId: Int) -> Bool {
        return getAllFavorites().contains(movieId)
    }
    
    func getAllFavorites() -> [Int] {
        return UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
    }
}
