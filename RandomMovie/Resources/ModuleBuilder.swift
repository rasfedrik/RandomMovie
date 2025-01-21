//
//  ModuleBuilder.swift
//  RandomMovie
//
//  Created by Семён Беляков on 20.01.2025.
//

import UIKit

protocol Builder {
    static func createRandomMoview() -> UIViewController
}

final class ModuleBuilder: Builder {
    
    static func createRandomMoview() -> UIViewController {
        let view = RandomMovieViewController()
        let networkService = NetworkDataFetch()
        let presenter = RandomMoviewPresenter(view: view, networkDataFetch: networkService)
        view.presenter = presenter
        
        return view
    }
    
}
