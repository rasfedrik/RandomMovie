//
//  MovieDetailsPresenter.swift
//  RandomMovie
//
//  Created by Семён Беляков on 22.01.2025.
//

import Foundation

protocol MovieDetailsViewProtocol: AnyObject {
    func openMovie(details: RandomMovieModel?)
}

protocol MovieDetailsViewPresenterProtocol: AnyObject {
    init(view: MovieDetailsViewProtocol, networkService: NetworkDataFetch, movie: RandomMovieModel?)
    func openMovieDetails()
}

final class MovieDetailsPresenter: MovieDetailsViewPresenterProtocol {
    
    weak var view: MovieDetailsViewProtocol?
    let networkService: NetworkDataFetchProtocol!
    var randomMovie: RandomMovieModel?
    
    init(view: MovieDetailsViewProtocol, networkService: NetworkDataFetch, movie: RandomMovieModel?) {
        self.view = view
        self.networkService = networkService
        self.randomMovie = movie
    }
    
    func openMovieDetails() {
        self.view?.openMovie(details: randomMovie)
    }
    
}
