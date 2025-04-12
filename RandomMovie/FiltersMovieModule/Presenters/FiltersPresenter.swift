//
//  FiltersPresenter.swift
//  RandomMovie
//
//  Created by Семён Беляков on 20.02.2025.
//

import Foundation

protocol FiltersPresenterProtocol: AnyObject {
    init(view: FiltersViewController, networkDataFetch: NetworkDataFetch, router: FiltersRouterProtocol)
    func applyFilters(_ filter: FiltersModel)
}

final class FiltersPresenter: FiltersPresenterProtocol {
    
    weak var view: FiltersViewController?
    let networkDataFetch: NetworkDataFetch!
    let router: FiltersRouterProtocol
    
    init(view: FiltersViewController, networkDataFetch: NetworkDataFetch, router: FiltersRouterProtocol) {
        self.view = view
        self.networkDataFetch = networkDataFetch
        self.router = router
    }
    
    func applyFilters(_ filter: FiltersModel) {
        router.closeFiltersAndOpenRandomMovies(with: filter)
    }
    
}
