//
//  ActorsPresenter.swift
//  RandomMovie
//
//  Created by Семён Беляков on 23.04.2025.
//

import UIKit

protocol ActorsViewControllerProtocol: AnyObject {
    func showAllActors(model: MovieDetailsModel?)
}

protocol ActorsPresenterProtocol: AnyObject {
    init(view: ActorsViewController, movieId: Int?, networkDataFetch: NetworkDataFetch!, navigationController: UINavigationController?)
    func fetchAllActors()
}

final class ActorsPresenter: ActorsPresenterProtocol {
    weak var view: ActorsViewController?
    private var movieId: Int?
    private var networkDataFetch: NetworkDataFetch!
    private var navigationController: UINavigationController?
    
    init(view: ActorsViewController, movieId: Int?, networkDataFetch: NetworkDataFetch!, navigationController: UINavigationController?) {
        self.view = view
        self.movieId = movieId
        self.networkDataFetch = networkDataFetch
        self.navigationController = navigationController
    }
    
    func fetchAllActors() {
        networkDataFetch.fetchData(
            endPoint: .movieByID(movieId),
            expecting: MovieDetailsModel?.self) { [weak self] result in
                guard let strongSelf = self else { return }
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let movie):
                        guard var movie = movie else { return }
                        guard var persons = movie.persons else { return }
                        
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
                            guard let strongSelf = self else { return }
                            movie.persons = persons
                            strongSelf.view?.showAllActors(model: movie)
                        }
                        
                    case .failure(let error):
                        print(error)
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

