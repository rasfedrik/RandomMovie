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
    private let contentView = MovieContentView()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentView()
        presenter.fetchMovieDetails()
    }
    
    // MARK: - Methods
    private func setupContentView() {
        view.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

// MARK: - Extensions
extension MovieDetailsViewController: MovieDetailsViewProtocol {
    
    func details(movieDetails: MovieDetailsModel?) {
        contentView.applySnapShot(movie: movieDetails)
        
        contentView.collectionView.reloadData()
//        let movieID = movieDetails?.id ?? 0
//        var name = movieDetails?.name ?? movieDetails?.alternativeName ?? "Название отсутствует"
//        let year = movieDetails?.year ?? 0
//        name += " (\(year))"
//        let description = movieDetails?.description ?? "Нет описания"
//        
//        var posterImage: UIImage?
//        if let data = movieDetails?.posterData {
//            posterImage = UIImage(data: data)
//        }
//        
//        scrollView.configure(id: movieID, posterImage: posterImage, movieName: name, description: description, isFavorite: FavoriteService().isFavorite(movieId: movieID))
    }
    
    func failure(error: Error) {
        print(error)
    }
    
}
