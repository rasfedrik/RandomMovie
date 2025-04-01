//
//  MovieDetailsPresenter.swift
//  RandomMovie
//
//  Created by Семён Беляков on 22.01.2025.
//

import Foundation

protocol MovieDetailsViewProtocol: AnyObject {
    func details(movieDetails: RandomMovieModel?, posterData: Data?)
    func failure(error: Error)
}

protocol MovieDetailsViewPresenterProtocol: AnyObject {
    init(view: MovieDetailsViewProtocol, movieId: Int?, networkDataFetch: NetworkDataFetch!)
    func fetchMovieDetails()
    func toggleFavorite(id: Int?)
    func isFavoriteMovie() -> Bool
}

final class MovieDetailsPresenter: MovieDetailsViewPresenterProtocol {
    
    weak var view: MovieDetailsViewProtocol?
    var movieId: Int?
    let networkDataFetch: NetworkDataFetch!
    private let favoriteService = FavoriteService()
    
    init(view: MovieDetailsViewProtocol,
         movieId: Int?, networkDataFetch: NetworkDataFetch!) {
        self.view = view
        self.movieId = movieId
        self.networkDataFetch = networkDataFetch
    }
    
    // MARK: - Methods
    func toggleFavorite(id: Int?) {
        guard movieId == id, let id = id else { return }
        favoriteService.toggleFavorite(movieId: id)
    }
    
    func isFavoriteMovie() -> Bool {
        guard let movieId = movieId else { return false }
        return favoriteService.isFavorite(movieId: movieId)
    }
    
    func fetchMovieDetails() {
        networkDataFetch.fetchData(
            endPoint: .movieByID(movieId),
            expecting: RandomMovieModel?.self) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let movie):
                        guard let movie = movie else { return }
                        
                        self.fetchPosterImage(url: movie.poster?.url) { result in
                            switch result {
                            case .success(let poster):
                                self.view?.details(
                                    movieDetails: movie,
                                    posterData: poster
                                )
                            case .failure(let error):
                                print("Failed to load image:", error)
                            }
                        }
                    case .failure(let error):
                        self.view?.failure(error: error)
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
