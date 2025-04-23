  //
//  RandomMoviePresenter.swift
//  RandomMovie
//
//  Created by Семён Беляков on 20.01.2025.
//

import Foundation

protocol RandomMovieViewProtocol: AnyObject {
    func success(moviePreview: MoviePreviewModel?)
    func winnerMovie(moviePreview: MoviePreviewModel?)
    func failure(error: Error)
}

protocol RandomMoviewPresenterProtocol: AnyObject {
    init(view: RandomMovieViewProtocol, networkDataFetch: NetworkDataFetchProtocol, router: RandomMoviesRouterProtocol)
    func loadRandomMovies(completion: @escaping (() -> Void))
    func fetchRandomMovie(endPoint: EndPoint, completion: @escaping () -> Void)
    func cancelRequest()
    func openFilters()
    func openDetails(movieId: Int?)
    func openMovieWinner(movieId: Int?)
    func updateFilters(_ filters: FiltersModel)
    func toggleFavorite(movieId: Int)
    var queue: OperationQueue { get }
    var numberOfCells: Int { get }
}

final class RandomMoviePresenter: RandomMoviewPresenterProtocol {
    var filters: FiltersModel?
    var router: RandomMoviesRouterProtocol
    weak var view: RandomMovieViewProtocol?
    private let networkDataFetch: NetworkDataFetchProtocol!
    private let favoriteService = FavoriteService()
    var queue = OperationQueue()
    var numberOfCells = 1
    var moviePreview: [MoviePreviewModel] = []
    
    init(view: RandomMovieViewProtocol, networkDataFetch: NetworkDataFetchProtocol, router: RandomMoviesRouterProtocol) {
        self.view = view
        self.networkDataFetch = networkDataFetch
        self.router = router
    }
    
    // MARK: - Navigation
    func openFilters() {
        router.openFilters()
    }
    
    func openDetails(movieId: Int?) {
        router.openMovieDetails(movieId: movieId)
    }
    
    // MARK: - Methods
    func cancelRequest() {
        moviePreview.removeAll()
        networkDataFetch.cancelRequests()
        queue.cancelAllOperations()
        filters = nil
    }
    
    func updateFilters(_ filters: FiltersModel) {
        self.filters = filters
    }
    
    func toggleFavorite(movieId: Int) {
        favoriteService.toggleFavorite(movieId: movieId)
    }
    
    func openMovieWinner(movieId: Int?) {
        let decoder = JSONDecoder()
        
        if let savedPreviewsData = UserDefaults.standard.data(forKey: KeysForUserDefaults.savedPreviewsKey),
           let savedPreviews = try? decoder.decode([MoviePreviewModel].self, from: savedPreviewsData) {
            self.moviePreview = savedPreviews
        }
        let movie = moviePreview.first(where: { $0.id == movieId })
        if let view = self.view {
            view.winnerMovie(moviePreview: movie)
        }
    }
    
    func loadRandomMovies(completion: @escaping (() -> Void)) {
        queue.maxConcurrentOperationCount = 1
        
        let blockOperation = BlockOperation {
            let group = DispatchGroup()
            
            for _ in (1...self.numberOfCells) {
                group.enter()
                self.queue.addOperation { [weak self] in
                    guard let strongSelf = self else {
                        group.leave()
                        return
                    }
                    strongSelf.fetchRandomMovie(endPoint: .random(with: strongSelf.filters)) {
                        group.leave()
                    }
                }
            }
            group.notify(queue: .main) {
                completion()
            }
        }
        self.queue.addOperation(blockOperation)
    }
    
    // MARK: - Fetch Movies
    func fetchRandomMovie(endPoint: EndPoint, completion: @escaping () -> Void) {
        networkDataFetch.fetchData(
            endPoint: endPoint,
            expecting: MoviePreviewModel?.self) { [weak self] result in
                guard let strongSelf = self else { return }
                
                DispatchQueue.main.async {
                    switch result {
                        
                    case .success(let movie):
                        guard var movie = movie else { return }
                        
                        strongSelf.fetchPosterImage(movie.poster?.url) { result in
                            switch result {
                                
                            case .success(let poster):
                                movie.posterData = poster
                                strongSelf.moviePreview.append(movie)
                                
                                if let view = strongSelf.view {
                                    view.success(moviePreview: movie)
                                }
                                
                                completion()
                            case .failure(let error):
                                print("Failed to load image:", error)
                                completion()
                            }
                        }
                    case .failure(let error):
                        if (error as NSError).code == NSURLErrorCancelled {
                            print("Request is cancelled")
                        } else {
                            if let view = strongSelf.view {
                                view.failure(error: error)
                            }
                        }
                        completion()
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
