//
//  FiltersPresenter.swift
//  RandomMovie
//
//  Created by Семён Беляков on 20.02.2025.
//

import Foundation

protocol FiltersPresenterProtocol: AnyObject {
    init(view: FiltersViewController, networkDataFetch: NetworkDataFetch, router: FiltersRouterProtocol)
    func applyFilters(_ filter: FiltersModel)
}

final class FiltersPresenter: FiltersPresenterProtocol {
    
    weak var view: FiltersViewController?
    let networkDataFetch: NetworkDataFetch!
    let router: FiltersRouterProtocol
    
    init(view: FiltersViewController, networkDataFetch: NetworkDataFetch, router: FiltersRouterProtocol) {
        self.view = view
        self.networkDataFetch = networkDataFetch
        self.router = router
    }
    
    func applyFilters(_ filter: FiltersModel) {
        router.closeFiltersAndOpenRandomMovies(with: filter)
    }
    
    
}
//    func filterName(filter: FiltersModel) {
//        networkDataFetch.fetchData(
//            endPoint: .random(with: filter),
//            expecting: PreviewForCollectionViewCellModel?.self) { [weak self] result in
//                guard let self = self else { return }
//                
//                DispatchQueue.main.async {
//                    switch result {
//                        
//                    case .success(let movie):
//                        guard var movie = movie else { return }
//                        self.fetchPosterImage(url: movie.poster?.url) { result in
//                            switch result {
//                            case .success(let poster):
//                                movie.posterData = poster
//                                
//                            case .failure(let error):
//                                print("Failed to load image:", error)
//                            }
//                        }
//                    case .failure(let error):
//                        self.view?.failure(error: error)
//                    }
//                }
//            }
//    }
//    
//    private func fetchPosterImage(url: String?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
//        let urlString = url ?? "https://image.openmoviedb.com/kinopoisk-st-images//actor_iphone/iphone360_6580433.jpg"
//        
//        guard let url = URL(string: urlString) else {
//            let error = NetworkError.invalidResponse(urlString)
//            print("Image URL == nil")
//            completion(.failure(error))
//            return
//        }
//        ImageLoader.share.imageLoader(url) { result in
//            DispatchQueue.main.async {
//                completion(result)
//            }
//        }
//    }
//}
