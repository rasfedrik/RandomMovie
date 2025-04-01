//
//  FavoriteMovieViewController.swift
//  RandomMovie
//
//  Created by Семён Беляков on 15.02.2025.
//

import UIKit

final class FavoriteMovieViewController: BaseViewController {
    
    // MARK: - Properties
    var presenter: FavoriteMoviePresenterProtocol!
    private let tableView = FavoriteMoviesTableView()
    private let favoriteService = FavoriteService()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainButtonsColorAfterTapped
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.fetchFavoriteMovies()
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension FavoriteMovieViewController: FavoriteMovieViewProtocol {
    
    func showAllFavoriteMovies(moviePreview: [MoviePreviewModel]?) {
        if let moviePreview = moviePreview {
            DispatchQueue.main.async {
                self.tableView.favoriteMoviesPreviewsData = moviePreview
                self.tableView.reloadData()
            }
        }
    }
}
