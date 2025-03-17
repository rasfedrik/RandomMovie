//
//  FavoriteMoviePresenter.swift
//  RandomMovie
//
//  Created by Семён Беляков on 15.02.2025.
//

import Foundation

protocol FavoriteMoviePresenterProtocol: AnyObject {
    init(view: FavoriteMovieViewController)
    func getDataFromUserDefaults() -> [RandomMovieModel]
}

final class FavoriteMoviePresenter: FavoriteMoviePresenterProtocol {
    
    weak var view: FavoriteMovieViewController?
    
    init(view: FavoriteMovieViewController) {
        self.view = view
    }
    
    func getDataFromUserDefaults() -> [RandomMovieModel] {
        let decoder = JSONDecoder()
        guard let favoriteMoviesData = UserDefaults.standard.data(forKey: "favoriteMovies"),
           let favoriteMovies = try? decoder.decode([RandomMovieModel].self, from: favoriteMoviesData)
        else {
            return []
        }
        return favoriteMovies
    }
    
}
