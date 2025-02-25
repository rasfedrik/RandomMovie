//
//  FiltersPresenter.swift
//  RandomMovie
//
//  Created by Семён Беляков on 20.02.2025.
//

import Foundation

protocol FiltersViewProtocol: AnyObject {
    func success(name: String, value: String)
    func failure(error: Error)
}

protocol FiltersPresenterProtocol: AnyObject {
    init(view: FiltersViewController, networkService: NetworkDataFetch)
    func filters(_ filters: [String:String])
}

final class FiltersPresenter: FiltersPresenterProtocol {
    func filters(_ filters: [String : String]) {
        
    }
    
    
    weak var view: FiltersViewController?
    var networkService: NetworkDataFetch!
    var randomPresenter: RandomMoviewPresenterProtocol?
    
    init(view: FiltersViewController, networkService: NetworkDataFetch) {
        self.view = view
        self.networkService = networkService
    }
    
}

