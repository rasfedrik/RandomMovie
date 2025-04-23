//
//  RandomMoviesModuleBuilder.swift
//  RandomMovie
//
//  Created by Семён Беляков on 20.01.2025.
//

import UIKit

protocol RandomModuleBuilderProtocol {
    func createRandomMovieModule(navigationController: UINavigationController) -> UIViewController
    func createFiltersModule(navigationController: UINavigationController) -> UIViewController
    func createMovieDetailsModule(navigationController: UINavigationController, movieId: Int?) -> UIViewController
}

final class RandomMoviesModuleBuilder: RandomModuleBuilderProtocol {
    
    // MARK: - RandomMovieModule
    func createRandomMovieModule(navigationController: UINavigationController) -> UIViewController {
        let view = RandomMoviesViewController()
        let networkDataFetch = NetworkDataFetch()
        let router = RandomMoviesRouter(navigationController: navigationController, moduleBuilder: self)
        let presenter = RandomMoviePresenter(view: view, networkDataFetch: networkDataFetch, router: router)
        view.presenter = presenter
        return view
    }
    
    // MARK: - MovieDetailsModule
    func createMovieDetailsModule(navigationController: UINavigationController, movieId: Int?) -> UIViewController {
        let view = MovieDetailsViewController()
        let networkDataFetch = NetworkDataFetch()
        let router = DetailsMovieRouter(view: view, navigationController: navigationController)
        let presenter = MovieDetailsPresenter(view: view, movieId: movieId, networkDataFetch: networkDataFetch, navigationController: navigationController, router: router)
        view.presenter = presenter
        return view
    }
    
    func createFiltersModule(navigationController: UINavigationController) -> UIViewController {
        let view = FiltersViewController()
        let networkDataFetch = NetworkDataFetch()
        let randomRouter = RandomMoviesRouter(navigationController: navigationController, moduleBuilder: self)
        
        let router = FiltersRouter(view: view, randomMoviesRouter: randomRouter, navigationController: navigationController)
        
        let presenter = FiltersPresenter(view: view, networkDataFetch: networkDataFetch, router: router)
        view.presenter = presenter
        return view
    }
    
}
