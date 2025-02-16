//
//  MovieDetailsViewController.swift
//  RandomMovie
//
//  Created by Семён Беляков on 22.01.2025.
//

import UIKit

final class MovieDetailsViewController: BaseViewController {
    
    var presenter: MovieDetailsPresenter!
    private let scrollView = MovieDetailsScrollView()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.openMovieDetails()
        setupScrollView()
    }
    
    // MARK: - Methods
    private func setupScrollView() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

// MARK: - Extensions
extension MovieDetailsViewController: MovieDetailsViewProtocol {
    
    func openMovie(details: RandomMovieModel?, posterData: PreviewForCollectionViewCellModel?) {
        
        var name = details?.name ?? details?.alternativeName ?? ""
        let year = details?.year ?? 0
        name += " (\(year))"
        
        let description = details?.description ?? "Нет описания"
        let posterImage = posterData?.getPosterImage()
        
        scrollView.configure(posterImage: posterImage, movieName: name, description: description)
    }
    
}
