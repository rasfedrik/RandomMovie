//
//  FavoritesMovieModuleBuilder.swift
//  RandomMovie
//
//  Created by Семён Беляков on 23.02.2025.
//

import UIKit

protocol FavoriteMoviesModuleBuilderProtocol {
    func createFavoriteMovieModule(navigationController: UINavigationController) -> UIViewController
    func createMovieDetailsModule(movieId: Int?) -> UIViewController
}

final class FavoritesMovieModuleBuilder: FavoriteMoviesModuleBuilderProtocol {
    
    // MARK: - FavoriteMovieModule
    func createFavoriteMovieModule(navigationController: UINavigationController) -> UIViewController {
        let view = FavoriteMovieViewController()
        let networkDataFetch = NetworkDataFetch()
        let router = FavoriteMovieRouter(navigationController: navigationController, moduleBuilder: self)
        let presenter = FavoriteMoviePresenter(view: view, networkDataFetch: networkDataFetch, router: router)
        view.presenter = presenter
        return view
    }
    
    // MARK: - DetailsModule
    func createMovieDetailsModule(movieId: Int?) -> UIViewController {
        let view = MovieDetailsViewController()
        let networkDataFetch = NetworkDataFetch()
        let presenter = MovieDetailsPresenter(view: view, movieId: movieId, networkDataFetch: networkDataFetch)
        view.presenter = presenter
        return view
    }
    
}
