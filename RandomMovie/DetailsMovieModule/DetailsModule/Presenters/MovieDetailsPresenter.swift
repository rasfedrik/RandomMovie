//
//  MovieDetailsPresenter.swift
//  RandomMovie
//
//  Created by Семён Беляков on 22.01.2025.
//

import UIKit

protocol MovieDetailsViewProtocol: AnyObject {
    func details(movieDetails: MovieDetailsModel?)
    func failure(error: Error)
}

protocol MovieDetailsViewPresenterProtocol: AnyObject {
    func fetchMovieDetails()
    func toggleFavorite(id: Int?)
    func openFullInfo(type: MovieDetailSection)
}

final class MovieDetailsPresenter: MovieDetailsViewPresenterProtocol {
    weak var view: MovieDetailsViewProtocol?
    var movieId: Int?
    let networkDataFetch: NetworkDataFetch!
    private let favoriteService = FavoriteService()
    private let navigationController: UINavigationController!
    private let router: DetailsMovieRouterProtocol
    
    init(view: MovieDetailsViewProtocol,
         movieId: Int?, networkDataFetch: NetworkDataFetch!, navigationController: UINavigationController?, router: DetailsMovieRouterProtocol) {
        self.view = view
        self.movieId = movieId
        self.networkDataFetch = networkDataFetch
        self.navigationController = navigationController
        self.router = router
    }
    
    // MARK: - Methods
    
    func openFullInfo(type: MovieDetailSection) {
        switch type {
        case .poster:
            break
        case .title:
            break
        case .ratings:
            break
        case .description:
            openWholePlot()
        case .persons:
            openAllActors()
        }
    }
    
    private func openWholePlot() {
        self.router.openWholePlot(movieId: movieId)
    }
    
    private func openAllActors() {
        self.router.openAllActors(movieId: movieId)
    }
    
    func toggleFavorite(id: Int?) {
        guard movieId == id, let id = id else { return }
        favoriteService.toggleFavorite(movieId: id)
    }
    
    func fetchMovieDetails() {
        networkDataFetch.fetchData(
            endPoint: .movieByID(movieId),
            expecting: MovieDetailsModel?.self) { [weak self] result in
                guard let strongSelf = self else { return }
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let movie):
                        guard var movie = movie else { return }
                        guard var persons = movie.persons else { return }
                        
                        if let view = strongSelf.view {
                            
                            strongSelf.fetchImage(url: movie.poster?.url) { result in
                                switch result {
                                case .success(let poster):
                                    movie.posterData = poster
                                case .failure(let error):
                                    print("Failed to load image:", error)
                                }
                            }
                            
                            let group = DispatchGroup()
                            for (index, person) in persons.enumerated() {
                                group.enter()
                                strongSelf.fetchImage(url: person.photo) { result in
                                    defer { group.leave() }
                                    
                                    switch result {
                                    case .success(let imagesData):
                                        var updatedPerson = person
                                        updatedPerson.personPhotoData = imagesData
                                        persons[index] = updatedPerson
                                    case .failure(let error):
                                        print("Failed to load image:", error)
                                    }
                                }
                            }
                            group.notify(queue: .main) {
                                movie.persons = persons
                                view.details(movieDetails: movie)
                            }
                        }
                        
                    case .failure(let error):
                        if let view = strongSelf.view {
                            view.failure(error: error)
                        }
                    }
                }
            }
    }
    
    private func fetchImage(url: String?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        
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
