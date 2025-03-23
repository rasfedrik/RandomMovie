//
//  FavoritesMovieModuleBuilder.swift
//  RandomMovie
//
//  Created by Семён Беляков on 23.02.2025.
//

import UIKit

protocol FavoritesMovieModuleBuilderProtocol {
    func createFavoriteMovieModule(navigationController: UINavigationController) -> UIViewController
}

final class FavoritesMovieModuleBuilder: FavoritesMovieModuleBuilderProtocol {
    
    // MARK: - FavoriteMovieModule
    func createFavoriteMovieModule(navigationController: UINavigationController) -> UIViewController {
        let view = FavoriteMovieViewController()
        let networkDataFetch = NetworkDataFetch()
        let presenter = FavoriteMoviePresenter(view: view, networkDataFetch: networkDataFetch)
        view.presenter = presenter
        return view
    }
    
}
