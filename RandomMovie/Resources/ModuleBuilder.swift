//
//  ModuleBuilder.swift
//  RandomMovie
//
//  Created by Семён Беляков on 20.01.2025.
//

import UIKit

protocol Builder {
    static func createRandomMovieModule() -> UIViewController
    static func createMovieDetailsModule(movie: RandomMovieModel?) -> UIViewController
}

final class ModuleBuilder: Builder {
    
    static func createRandomMovieModule() -> UIViewController {
        let view = RandomMovieViewController()
        let networkService = NetworkDataFetch()
        let presenter = RandomMoviewPresenter(view: view, networkDataFetch: networkService)
        view.presenter = presenter
        
        return view
    }
    
    static func createMovieDetailsModule(movie: RandomMovieModel?) -> UIViewController {
        let view = MovieDetailsViewController()
        let networkService = NetworkDataFetch()
        let presenter = MovieDetailsPresenter(view: view, networkService: networkService, movie: movie)
        
        view.presenter = presenter
        
        return view
    }
    
}
