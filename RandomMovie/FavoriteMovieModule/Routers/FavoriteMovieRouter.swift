//
//  FavoriteMovieRouter.swift
//  RandomMovie
//
//  Created by Семён Беляков on 02.04.2025.
//

import UIKit

protocol FavoriteMovieRouterProtocol {
    func openMovieDetails(movieId: Int?)
    func popFavoriteMovies()
}

final class FavoriteMovieRouter: FavoriteMovieRouterProtocol {
    
    let navigationController: UINavigationController?
    private let moduleBuilder: FavoriteMoviesModuleBuilderProtocol
    
    init(navigationController: UINavigationController?, moduleBuilder: FavoriteMoviesModuleBuilderProtocol) {
        self.navigationController = navigationController
        self.moduleBuilder = moduleBuilder
    }
    
    func popFavoriteMovies() {
        guard let navController = navigationController else { return }
        if let favoriteMoviesVC = navController.viewControllers.first(where: { $0 is FavoriteMovieViewController }) as? FavoriteMovieViewController {
            navController.popToViewController(favoriteMoviesVC, animated: true)
        }
    }
    
    func openMovieDetails(movieId: Int?) {
        guard let navController = navigationController else { return }
        let detailsVC = moduleBuilder.createMovieDetailsModule(navigationController: navController, movieId: movieId)
        navController.pushViewController(detailsVC, animated: true)
    }
}
