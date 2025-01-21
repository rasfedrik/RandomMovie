//
//  RandomMoviewPresenter.swift
//  RandomMovie
//
//  Created by Семён Беляков on 20.01.2025.
//

import Foundation

protocol RandomMovieViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol RandomMoviewPresenterProtocol: AnyObject {
    init(view: RandomMovieViewProtocol, networkDataFetch: NetworkDataFetchProtocol)
    func getData()
    var data: [RandomMovieModel]? { get set }
}

final class RandomMoviewPresenter: RandomMoviewPresenterProtocol {
    
    var data: [RandomMovieModel]? = []
    weak var view: RandomMovieViewProtocol?
    private let networkDataFetch: NetworkDataFetchProtocol!
    
    init(view: RandomMovieViewProtocol, networkDataFetch: NetworkDataFetchProtocol) {
        self.view = view
        self.networkDataFetch = networkDataFetch
        
    }
    
    func getData() {
        networkDataFetch.fetchData(endPoint: .random,
                                   expecting: RandomMovieModel.self) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let movies):
                    guard var data = self.data else { return }
                    
                    if !data.isEmpty {
                        data.removeAll()
                    }
                    data.append(movies)
                    self.data = data
                    
                    self.view?.success()
                    
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
}
