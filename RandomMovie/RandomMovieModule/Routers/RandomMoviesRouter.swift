//
//  RandomMoviesRouter.swift
//  RandomMovie
//
//  Created by Семён Беляков on 23.02.2025.
//

import UIKit

protocol RandomMoviesRouterProtocol {
    init(navigationController: UINavigationController?, moduleBuilder: RandomModuleBuilderProtocol)
    
    func openRandomMovies(with filters: FiltersModel)
    func popRandomMovies(with filters: FiltersModel)
    func openFilters()
    func openMovieDetails(movieId: Int?)
}

final class RandomMoviesRouter: RandomMoviesRouterProtocol {
    
    weak var navigationController: UINavigationController?
    private let moduleBuilder: RandomModuleBuilderProtocol
    
    init(navigationController: UINavigationController?, moduleBuilder: RandomModuleBuilderProtocol) {
        self.navigationController = navigationController
        self.moduleBuilder = moduleBuilder
    }
    
    func openRandomMovies(with filters: FiltersModel) {
        guard let navController = navigationController else { return }
        let randomMoviesVC = moduleBuilder.createRandomMovieModule(navigationController: navController)
        navController.pushViewController(randomMoviesVC, animated: true)
    }
    
    func popRandomMovies(with filters: FiltersModel) {
        guard let navController = navigationController else { return }
        if let randomMoviesVC = navController.viewControllers.first(where: { $0 is RandomMoviesViewController }) as? RandomMoviesViewController {
            navController.popToViewController(randomMoviesVC, animated: true)
            
            let presenter = randomMoviesVC.presenter
            presenter?.updateFilters(filters)
        }
    }
    
    func openFilters() {
        guard let navController = navigationController else { return }
        let filtersVC = moduleBuilder.createFiltersModule(navigationController: navController)
        navController.pushViewController(filtersVC, animated: true)
    }
    
    func openMovieDetails(movieId: Int?) {
        guard let navController = navigationController else { return }
        let detailsVC = moduleBuilder.createMovieDetailsModule(navigationController: navController, movieId: movieId)
        navController.pushViewController(detailsVC, animated: true)
    }
    
}
