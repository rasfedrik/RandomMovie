//
//  FiltersRouter.swift
//  RandomMovie
//
//  Created by Семён Беляков on 02.03.2025.
//

import UIKit

protocol FiltersRouterProtocol {
    func closeFiltersAndOpenRandomMovies(with filters: FiltersModel)
}

final class FiltersRouter: FiltersRouterProtocol {
    
    weak var view: FiltersViewController?
    var randomMoviesRouter: RandomMoviesRouterProtocol!
    var navigationController: UINavigationController!
    
    init(view: FiltersViewController, randomMoviesRouter: RandomMoviesRouterProtocol!, navigationController: UINavigationController) {
        self.view = view
        self.randomMoviesRouter = randomMoviesRouter
        self.navigationController = navigationController
    }
    
    func closeFiltersAndOpenRandomMovies(with filters: FiltersModel) {
        self.randomMoviesRouter.popRandomMovies(with: filters)
    }
    
}
