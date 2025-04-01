//
//  MovieDetailsViewController.swift
//  RandomMovie
//
//  Created by Семён Беляков on 22.01.2025.
//

import UIKit

final class MovieDetailsViewController: BaseViewController {
    
    // MARK: - Properties
    var presenter: MovieDetailsPresenter!
    private let scrollView = MovieDetailsScrollView()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.fetchMovieDetails()
        setupScrollView()
        scrollView.onTap = { [weak self] id in
            guard let self = self else { return }
            self.presenter.toggleFavorite(id: id)
            print(id)
        }
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
    
    func details(movieDetails: RandomMovieModel?, posterData: Data?) {
        let movieID = movieDetails?.id ?? 0
        var name = movieDetails?.name ?? movieDetails?.alternativeName ?? "Название отсутствует"
        let year = movieDetails?.year ?? 0
        name += " (\(year))"
        let description = movieDetails?.description ?? "Нет описания"
        var posterImage: UIImage?
        if let data = posterData {
            posterImage = UIImage(data: data)
        }
        
        scrollView.configure(id: movieID, posterImage: posterImage, movieName: name, description: description, isFavorite: FavoriteService().isFavorite(movieId: movieID))
    }
    
    func failure(error: Error) {
        print(error)
    }
    
}
