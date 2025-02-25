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
        presenter.fetchMovieDetails()
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
    func success(movieDetails: RandomMovieModel?, posterData: Data?) {
        
        var name = movieDetails?.name ?? movieDetails?.alternativeName ?? "Название отсутствует"
        
        let year = movieDetails?.year ?? 0
        name += " (\(year))"
        
        let description = movieDetails?.description ?? "Нет описания"
        
        var posterImage: UIImage?
        if let data = posterData {
            posterImage = UIImage(data: data)
        }
        
        scrollView.configure(posterImage: posterImage, movieName: name, description: description)
    }
    
    func failure(error: Error) {
        print(error)
    }
    
}
