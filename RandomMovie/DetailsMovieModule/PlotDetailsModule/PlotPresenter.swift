//
//  PlotPresenter.swift
//  RandomMovie
//
//  Created by Семён Беляков on 23.04.2025.
//

import UIKit

protocol PlotViewControllerProtocol: AnyObject {
    func showWholePlot(model: MovieDetailsModel?)
}

protocol PlotPresenterProtocol: AnyObject {
    init(view: PlotViewController, movieId: Int?, networkDataFetch: NetworkDataFetch!, navigationController: UINavigationController?)
    func fetchPlot()
}

final class PlotPresenter: PlotPresenterProtocol {
    
    weak var view: PlotViewController?
    var movieId: Int?
    let networkDataFetch: NetworkDataFetch!
    let navigationController: UINavigationController!
    
    init(view: PlotViewController, movieId: Int?, networkDataFetch: NetworkDataFetch!, navigationController: UINavigationController?) {
        self.view = view
        self.movieId = movieId
        self.networkDataFetch = networkDataFetch
        self.navigationController = navigationController
    }
    
    func fetchPlot() {
        networkDataFetch.fetchData(endPoint: .movieByID(movieId), expecting: MovieDetailsModel.self) { [weak self] result in
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let movie):
                    strongSelf.view?.showWholePlot(model: movie)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
}
