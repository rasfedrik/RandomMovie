//
//  FavoritesMovieModuleBuilder.swift
//  RandomMovie
//
//  Created by Семён Беляков on 23.02.2025.
//

import UIKit

protocol FavoritesMovieModuleBuilderProtocol {
    func createFavoriteMovie(navigationController: UINavigationController) -> UIViewController
}

final class FavoritesMovieModuleBuilder: FavoritesMovieModuleBuilderProtocol {
    
    // MARK: - FavoriteMovieModule
    func createFavoriteMovie(navigationController: UINavigationController) -> UIViewController {
        let view = FavoriteMovieViewController()
        let presenter = FavoriteMoviePresenter(view: view)
        view.presenter = presenter
        return view
    }
    
}
