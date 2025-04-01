//
//  FavoriteMoviePresenter.swift
//  RandomMovie
//
//  Created by Семён Беляков on 15.02.2025.
//

import Foundation

protocol FavoriteMovieViewProtocol: AnyObject {
    func showAllFavoriteMovies(moviePreview: [MoviePreviewModel]?)
}

protocol FavoriteMoviePresenterProtocol: AnyObject {
    init(view: FavoriteMovieViewProtocol, networkDataFetch: NetworkDataFetchProtocol)
    func fetchFavoriteMovies()
}

final class FavoriteMoviePresenter: FavoriteMoviePresenterProtocol {
    
    weak var view: FavoriteMovieViewProtocol?
    private let networkDataFetch: NetworkDataFetchProtocol!
    private var movies: [MoviePreviewModel] = []
    init(view: FavoriteMovieViewProtocol, networkDataFetch: NetworkDataFetchProtocol) {
        self.view = view
        self.networkDataFetch = networkDataFetch
    }
    
    // MARK: - Methods
    
    private func sortByName() {
        movies.sort {
            guard let name1 = $0.name, let name2 = $1.name else { return false }
            return name1.localizedCaseInsensitiveCompare(name2) == .orderedAscending
        }
    }
    
    // MARK: - Fetch Movies
    
    func fetchFavoriteMovies() {
        movies.removeAll()
        
        let savedMoviesID = FavoriteService().getAllFavorites()
        guard !savedMoviesID.isEmpty else {
            view?.showAllFavoriteMovies(moviePreview: [])
            return
        }
        
        let group = DispatchGroup()
        
        for movieID in savedMoviesID {
            group.enter()
            networkDataFetch.fetchData(endPoint: .movieByID(movieID), expecting: MoviePreviewModel?.self) { [weak self] result in
                guard let self = self else {
                    group.leave()
                    return
                }
                
                DispatchQueue.main.async {
                    switch result {
                        
                    case .success(let movie):
                        guard var movie = movie else {
                            group.leave()
                            return
                        }
                        
                        self.loadPoster(movie.poster?.url) { result in
                            switch result {
                                
                            case .success(let poster):
                                movie.posterData = poster
                                DispatchQueue.main.async {
                                    self.movies.append(movie)
                                }
                            case .failure(let error):
                                print("Failed to load image:", error)
                            }
                            group.leave()
                        }
                    case .failure(let error):
                        print("Failed to load movie:", error)
                        group.leave()
                    }
                }
            }
        }
        group.notify(queue: .main) { [weak self] in
            guard let self = self else {
                group.leave()
                return
            }
            self.sortByName()
            self.view?.showAllFavoriteMovies(moviePreview: movies)
        }
    }
    
    private func loadPoster(_ url: String?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
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
