//
//  RandomMoviewPresenter.swift
//  RandomMovie
//
//  Created by Семён Беляков on 20.01.2025.
//

import Foundation

protocol RandomMovieViewProtocol: AnyObject {
    func success(moviePreview: PreviewForCollectionViewCellModel?)
    func failure(error: Error)
}

protocol RandomMoviewPresenterProtocol: AnyObject {
    init(view: RandomMovieViewProtocol, networkDataFetch: NetworkDataFetchProtocol, router: RandomMoviesRouterProtocol)
    func fetchRandomMovie(completion: @escaping () -> Void)
    func cancelRequest()
    func openFilters()
    func openDetails(movieId: Int?)
    func updateFilters(_ filters: FiltersModel)
}

final class RandomMoviewPresenter: RandomMoviewPresenterProtocol {
    
    var filters: FiltersModel?
    var router: RandomMoviesRouterProtocol
    weak var view: RandomMovieViewProtocol?
    private let networkDataFetch: NetworkDataFetchProtocol!
    
    init(view: RandomMovieViewProtocol, networkDataFetch: NetworkDataFetchProtocol, router: RandomMoviesRouterProtocol) {
        self.view = view
        self.networkDataFetch = networkDataFetch
        self.router = router
    }
    
    func cancelRequest() {
        networkDataFetch.cancelRequests()
        filters = nil
    }
    
    func openFilters() {
        router.openFilters()
    }
    
    func openDetails(movieId: Int?) {
        router.openMovieDetails(movieId: movieId)
    }
    
    func updateFilters(_ filters: FiltersModel) {
        self.filters = filters
    }
    
    func fetchRandomMovie(completion: @escaping () -> Void) {
        networkDataFetch.fetchData(
            endPoint: .random(with: filters),
            expecting: PreviewForCollectionViewCellModel?.self) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    switch result {
                        
                    case .success(let movie):
                        guard var movie = movie else { return }
                        
                        self.fetchPosterImage(url: movie.poster?.url) { result in
                            switch result {
                                
                            case .success(let poster):
                                movie.posterData = poster
                                self.view?.success(moviePreview: movie)
                                completion()
                            case .failure(let error):
                                print("Failed to load image:", error)
                                completion()
                            }
                        }
                    case .failure(let error):
                        self.view?.failure(error: error)
                        completion()
                    }
                }
            }
    }
    
    private func fetchPosterImage(url: String?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let urlString = url ?? "https://image.openmoviedb.com/kinopoisk-st-images//actor_iphone/iphone360_6580433.jpg"
        
        guard let url = URL(string: urlString) else {
            let error = NetworkError.invalidResponse(urlString)
            print("Image URL == nil")
            completion(.failure(error))
            return
        }
        ImageLoader.share.imageLoader(url) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
