//
//  MovieDetailsPresenter.swift
//  RandomMovie
//
//  Created by Семён Беляков on 22.01.2025.
//

import Foundation

protocol MovieDetailsViewProtocol: AnyObject {
    func openMovie(details: RandomMovieModel?, posterData: PreviewForCollectionViewCellModel?)
}

protocol MovieDetailsViewPresenterProtocol: AnyObject {
    init(view: MovieDetailsViewProtocol, networkService: NetworkDataFetch, movie: RandomMovieModel?, posterData: PreviewForCollectionViewCellModel?)
    func openMovieDetails()
}

final class MovieDetailsPresenter: MovieDetailsViewPresenterProtocol {
    
    weak var view: MovieDetailsViewProtocol?
    let networkService: NetworkDataFetchProtocol!
    var randomMovie: RandomMovieModel?
    var posterData: PreviewForCollectionViewCellModel?
    
    init(view: MovieDetailsViewProtocol, networkService: NetworkDataFetch, movie: RandomMovieModel?, posterData: PreviewForCollectionViewCellModel?) {

        self.view = view
        self.networkService = networkService
        self.randomMovie = movie
        self.posterData = posterData
    }
    
    func openMovieDetails() {
        self.view?.openMovie(details: randomMovie, posterData: posterData)
    }
    
}
