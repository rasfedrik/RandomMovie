//
//  DetailsModuleBuilder.swift
//  RandomMovie
//
//  Created by Семён Беляков on 23.04.2025.
//

import UIKit

protocol DetailsModuleBuilderProtocol {
    func createDetailsModule(navigationController: UINavigationController, movieId: Int?) -> UIViewController
    func createAllPlot(navigationController: UINavigationController, movieId: Int?) -> UIViewController
    func createAllActors(navigationController: UINavigationController, movieId: Int?) -> UIViewController
}

final class DetailsModuleBuilder: DetailsModuleBuilderProtocol {
    func createDetailsModule(navigationController: UINavigationController, movieId: Int?) -> UIViewController {
        let view = MovieDetailsViewController()
        let networkDataFetch = NetworkDataFetch()
        let router = DetailsMovieRouter(view: view, navigationController: navigationController)
        let presenter = MovieDetailsPresenter(view: view, movieId: movieId, networkDataFetch: networkDataFetch, navigationController: navigationController, router: router)
        view.presenter = presenter
        return view
    }
    
    func createAllPlot(navigationController: UINavigationController, movieId: Int?) -> UIViewController {
        let view = PlotViewController()
        let networkDataFetch = NetworkDataFetch()
        let presenter = PlotPresenter(view: view, movieId: movieId, networkDataFetch: networkDataFetch, navigationController: navigationController)
        view.presenter = presenter
        return view
    }
    
    func createAllActors(navigationController: UINavigationController, movieId: Int?) -> UIViewController {
        let view = ActorsViewController()
        let networkDataFetch = NetworkDataFetch()
        let presenter = ActorsPresenter(view: view, movieId: movieId, networkDataFetch: networkDataFetch, navigationController: navigationController)
        view.presenter = presenter
        return view
    }
    
}
