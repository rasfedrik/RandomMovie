//
//  RandomMovieRouter.swift
//  RandomMovie
//
//  Created by Семён Беляков on 23.02.2025.
//

import UIKit

protocol RandomRouterProtocol {
    func openRandomMovies()
    func openFilters()
    func openMovieDetails(movieId: Int?)
}

final class RandomMovieRouter: RandomRouterProtocol {
    
    weak var navigationController: UINavigationController?
    private let moduleBuilder: RandomModuleBuilderProtocol
    
    init(navigationController: UINavigationController?, moduleBuilder: RandomModuleBuilderProtocol) {
        self.navigationController = navigationController
        self.moduleBuilder = moduleBuilder
    }
    
    func openRandomMovies() {
        guard let navController = navigationController else { return }
        let randomMoviesVC = moduleBuilder.createRandomMovieModule(navigationController: navController)
        navController.pushViewController(randomMoviesVC, animated: true)
    }
    
    func openFilters() {
        guard let navController = navigationController else { return }
        let filtersVC = moduleBuilder.createFiltersModule()
        navController.pushViewController(filtersVC, animated: true)
    }
    
    func openMovieDetails(movieId: Int?) {
        guard let navController = navigationController else { return }
        let detailsVC = moduleBuilder.createMovieDetailsModule(movieId: movieId)
        navController.pushViewController(detailsVC, animated: true)
    }
    
}
