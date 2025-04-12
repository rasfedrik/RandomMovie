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
    init(view: FavoriteMovieViewProtocol, networkDataFetch: NetworkDataFetchProtocol, router: FavoriteMovieRouter)
    func fetchFavoriteMovies()
    func openDetails(by id: Int)
}

final class FavoriteMoviePresenter: FavoriteMoviePresenterProtocol {
    
    weak var view: FavoriteMovieViewProtocol?
    private let networkDataFetch: NetworkDataFetchProtocol!
    private var movies: [MoviePreviewModel] = []
    private let router: FavoriteMovieRouter
    init(view: FavoriteMovieViewProtocol, networkDataFetch: NetworkDataFetchProtocol, router: FavoriteMovieRouter) {
        self.view = view
        self.networkDataFetch = networkDataFetch
        self.router = router
    }
    
    // MARK: - Navigation
    func openDetails(by id: Int) {
        router.openMovieDetails(movieId: id)
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
            if let view = self.view {
                view.showAllFavoriteMovies(moviePreview: [])
            }
            return
        }
        
        let group = DispatchGroup()
        
        for movieID in savedMoviesID {
            group.enter()
            networkDataFetch.fetchData(endPoint: .movieByID(movieID), expecting: MoviePreviewModel?.self) { [weak self] result in
                guard let strongSelf = self else {
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
                        
                        strongSelf.loadPoster(movie.poster?.url) { result in
                            switch result {
                                
                            case .success(let poster):
                                movie.posterData = poster
                                DispatchQueue.main.async {
                                    strongSelf.movies.append(movie)
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
            guard let strongSelf = self else {
                group.leave()
                return
            }
            strongSelf.sortByName()
            if let view = strongSelf.view {
                view.showAllFavoriteMovies(moviePreview: strongSelf.movies)
            }
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
