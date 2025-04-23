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
        contentViewOnTap()
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
    
    private func contentViewOnTap() {
        contentView.onTap = { [weak self] id in
            guard let strongSelf = self else { return }
            strongSelf.presenter.toggleFavorite(id: id)
        }
        contentView.showAllInfoOnTap = { [weak self] type in
            guard let strongSelf = self else { return }
            strongSelf.presenter.openFullInfo(type: type)
        }
    }
    
}

// MARK: - Extensions
extension MovieDetailsViewController: MovieDetailsViewProtocol {
    
    func details(movieDetails: MovieDetailsModel?) {
        contentView.applySnapshot(movie: movieDetails)
    }
    
    func failure(error: Error) {
        print(error)
    }
    
}
