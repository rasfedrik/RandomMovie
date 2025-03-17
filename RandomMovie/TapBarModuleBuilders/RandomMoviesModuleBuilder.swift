//
//  ModuleBuilder.swift
//  RandomMovie
//
//  Created by Семён Беляков on 20.01.2025.
//

import UIKit

protocol RandomModuleBuilderProtocol {
    func createRandomMovieModule(navigationController: UINavigationController) -> UIViewController
    func createMovieDetailsModule(movieId: Int?) -> UIViewController
    func createFiltersModule(navigationController: UINavigationController) -> UIViewController
}

final class RandomMoviesModuleBuilder: RandomModuleBuilderProtocol {
    
    // MARK: - RandomMovieModule
    func createRandomMovieModule(navigationController: UINavigationController) -> UIViewController {
        let view = RandomMoviesViewController()
        let networkService = NetworkDataFetch()
        let router = RandomMoviesRouter(navigationController: navigationController, moduleBuilder: self)
        let presenter = RandomMoviewPresenter(view: view, networkDataFetch: networkService, router: router)
        view.presenter = presenter
        return view
    }
    
    // MARK: - MovieDetailsModule
    func createMovieDetailsModule(movieId: Int?) -> UIViewController {
        let view = MovieDetailsViewController()
        let networkDataFetch = NetworkDataFetch()
        let presenter = MovieDetailsPresenter(view: view, movieId: movieId, networkDataFetch: networkDataFetch)
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
