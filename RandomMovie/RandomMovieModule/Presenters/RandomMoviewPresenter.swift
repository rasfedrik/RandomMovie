//
//  RandomMoviewPresenter.swift
//  RandomMovie
//
//  Created by Семён Беляков on 20.01.2025.
//

import Foundation

protocol RandomMovieViewProtocol: AnyObject {
    func success(posterData: Data?)
    func failure(error: Error)
}

protocol RandomMoviewPresenterProtocol: AnyObject {
    init(view: RandomMovieViewProtocol, networkDataFetch: NetworkDataFetchProtocol)
    func getData()
    var data: RandomMovieModel? { get set }
}

final class RandomMoviewPresenter: RandomMoviewPresenterProtocol {
    
    var data: RandomMovieModel?
    weak var view: RandomMovieViewProtocol?
    private let networkDataFetch: NetworkDataFetchProtocol!
    
    init(view: RandomMovieViewProtocol, networkDataFetch: NetworkDataFetchProtocol) {
        self.view = view
        self.networkDataFetch = networkDataFetch
    }
    
    func getData() {
        networkDataFetch.fetchData(endPoint: .random,
                                   expecting: RandomMovieModel?.self) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let movie):
                    self.data = movie
                    
                    let urlString = movie?.poster?.url ?? "https://image.openmoviedb.com/kinopoisk-st-images//actor_iphone/iphone360_6580433.jpg"
                    
                    guard let url = URL(string: urlString) else {
                        print("Image URL == nil")
                        return
                    }
                    
                    ImageLoader.share.imageLoader(url) { [weak self] result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let poster):
                                self?.view?.success(posterData: poster)
                            case .failure(let error):
                                self?.view?.success(posterData: nil)
                                print("Failed to load image:", error)
                            }
                        }
                    }
                    
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
}
