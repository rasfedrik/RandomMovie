//
//  FavoriteMoviePresenter.swift
//  RandomMovie
//
//  Created by Семён Беляков on 15.02.2025.
//

import Foundation

protocol FavoriteMovieViewProtocol: AnyObject {
    func success(moviePreview: MoviePreviewModel?)
}

protocol FavoriteMoviePresenterProtocol: AnyObject {
    init(view: FavoriteMovieViewController, networkDataFetch: NetworkDataFetchProtocol)
    func fetchFavoriteMovies()
}

final class FavoriteMoviePresenter: FavoriteMoviePresenterProtocol {
    
    weak var view: FavoriteMovieViewController?
    private let networkDataFetch: NetworkDataFetchProtocol!
    
    init(view: FavoriteMovieViewController, networkDataFetch: NetworkDataFetchProtocol) {
        self.view = view
        self.networkDataFetch = networkDataFetch
    }
    
    // MARK: - Fetch Movies
    func fetchFavoriteMovies() {
        let decoder = JSONDecoder()
        if let savedMoviesIdData = UserDefaults.standard.data(forKey: "favoriteMovieIDs"),
            let savedMoviesID = try? decoder.decode([FavoriteMovieModel].self, from: savedMoviesIdData) {
            
            for movieID in savedMoviesID {
                networkDataFetch.fetchData(endPoint: .movieByID(movieID.id), expecting: MoviePreviewModel?.self) { [weak self] result in
                    guard let self = self else { return }
                    
                    DispatchQueue.main.async {
                        switch result {
                            
                        case .success(let movie):
                            guard var movie = movie else { return }
                            self.fetchPosterImage(movie.poster?.url) { result in
                                switch result {
                                    
                                case .success(let poster):
                                    movie.posterData = poster
                                    self.view?.success(moviePreview: movie)
                                case .failure(let error):
                                    print("Failed to load image:", error)
                                }
                            }
                        case .failure(let error):
                            print("Failed to load movie:", error)
                        }
                    }
                }
            }
        }
    }
    
    private func fetchPosterImage(_ url: String?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let urlString = url ?? DefaultImageUrl.url
        
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
