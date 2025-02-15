//
//  ModuleBuilder.swift
//  RandomMovie
//
//  Created by Семён Беляков on 20.01.2025.
//

import UIKit

protocol Builder {
    static func createTapBarController() -> UITabBarController
    static func createRandomMovieModule() -> UIViewController
    static func createMovieDetailsModule(movie: RandomMovieModel?) -> UIViewController
    static func createFavoriteMovie() -> UIViewController
}

final class ModuleBuilder: Builder {
    
    // MARK: - TapBarController
    static func createTapBarController() -> UITabBarController {
        let tapBarController = UITabBarController()
        
        let randomMovieVC = createRandomMovieModule()
        let randomMovieNav = UINavigationController(rootViewController: randomMovieVC)
        
        let favoriteMovieVC = createFavoriteMovie()
        let favoriteMovieNav = UINavigationController(rootViewController: favoriteMovieVC)
        
        randomMovieNav.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "movieclapper.fill"), tag: 0)
        favoriteMovieNav.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "star.square.fill"), tag: 1)
        
        tapBarController.viewControllers = [randomMovieNav, favoriteMovieNav]
        
        return tapBarController
    }
    
    // MARK: - RandomMovieModule
    static func createRandomMovieModule() -> UIViewController {
        let view = RandomMovieViewController()
        let networkService = NetworkDataFetch()
        let presenter = RandomMoviewPresenter(view: view, networkDataFetch: networkService)
        view.presenter = presenter
        
        return view
    }
    
    // MARK: - MovieDetailsModule
    static func createMovieDetailsModule(movie: RandomMovieModel?) -> UIViewController {
        let view = MovieDetailsViewController()
        let networkService = NetworkDataFetch()
        let presenter = MovieDetailsPresenter(view: view, networkService: networkService, movie: movie)
        view.presenter = presenter
        
        return view
    }
    
    // MARK: - FavoriteMovieModule
    static func createFavoriteMovie() -> UIViewController {
        let view = FavoriteMovieViewController()
        let presenter = FavoriteMoviePresenter(view: view)
        view.presenter = presenter
        
        return view
    }
    
}
