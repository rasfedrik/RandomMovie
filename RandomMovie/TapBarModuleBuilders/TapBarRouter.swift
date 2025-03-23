//
//  TapBarRouter.swift
//  RandomMovie
//
//  Created by Семён Беляков on 23.02.2025.
//

import UIKit

protocol TapBarRouterProtocol {
    func createTapBarController() -> UITabBarController
}

final class TapBarRouter: TapBarRouterProtocol {
    
    func createTapBarController() -> UITabBarController {
        let tapBarController = UITabBarController()
        tapBarController.tabBar.tintColor = .mainButtonsColor
        tapBarController.tabBar.barTintColor = .mainButtonsColorAfterTapped
        
        let randomMoviesNavController = UINavigationController()
        let favoritesMovieNavController = UINavigationController()
        
        let randomMoviesVC = RandomMoviesModuleBuilder().createRandomMovieModule(navigationController: randomMoviesNavController)
        
        let favoritesMovieVC = FavoritesMovieModuleBuilder().createFavoriteMovieModule(navigationController: favoritesMovieNavController)
        
        randomMoviesNavController.viewControllers = [randomMoviesVC]
        favoritesMovieNavController.viewControllers = [favoritesMovieVC]
        
        randomMoviesNavController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "movieclapper.fill"), tag: 0)
        favoritesMovieNavController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "star.square.fill"), tag: 1)
        
        tapBarController.viewControllers = [randomMoviesNavController, favoritesMovieNavController]
        
        return tapBarController
    }
    
}
