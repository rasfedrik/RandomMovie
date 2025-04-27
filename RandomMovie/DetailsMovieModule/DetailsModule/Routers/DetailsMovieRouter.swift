//
//  DetailsMovieRouter.swift
//  RandomMovie
//
//  Created by Семён Беляков on 22.04.2025.
//

import UIKit

protocol DetailsMovieRouterProtocol {
    func openWholePlot(movieId: Int?)
    func openAllActors(movieId: Int?)
}

final class DetailsMovieRouter: DetailsMovieRouterProtocol {
    
    weak var navigationController: UINavigationController!
    weak var view: MovieDetailsViewController?
    private let moduleBuilder: DetailsModuleBuilderProtocol
    
    init(view: MovieDetailsViewController?, navigationController: UINavigationController?, moduleBuilder: DetailsModuleBuilderProtocol = DetailsModuleBuilder()) {
        self.view = view
        self.navigationController = navigationController
        self.moduleBuilder = moduleBuilder
    }
    
    func openWholePlot(movieId: Int?) {
        guard let navController = navigationController else { return }
        let plotVC = moduleBuilder.createAllPlot(navigationController: navController, movieId: movieId)
        navController.pushViewController(plotVC, animated: true)
    }
    
    func openAllActors(movieId: Int?) {
        guard let navController = navigationController else { return }
        let actorsVC = moduleBuilder.createAllActors(navigationController: navController, movieId: movieId)
        navController.pushViewController(actorsVC, animated: true)
    }
}
