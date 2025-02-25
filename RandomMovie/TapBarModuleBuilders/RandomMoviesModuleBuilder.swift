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
    func createFiltersModule() -> UIViewController
}

final class RandomMoviesModuleBuilder: RandomModuleBuilderProtocol {
    
    // MARK: - RandomMovieModule
    func createRandomMovieModule(navigationController: UINavigationController) -> UIViewController {
        let view = RandomMovieViewController()
        let networkService = NetworkDataFetch()
        let router = RandomMovieRouter(navigationController: navigationController, moduleBuilder: self)
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
    
    func createFiltersModule() -> UIViewController {
        let view = FiltersViewController()
        let networkDataFetch = NetworkDataFetch()
        let presenter = FiltersPresenter(view: view, networkService: networkDataFetch)
        view.presenter = presenter
        return view
    }
    
}
