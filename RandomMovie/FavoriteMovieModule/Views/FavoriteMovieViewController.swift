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
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Любимые фильмы"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.fetchFavoriteMovies()
        setupUI()
        tableView.onTap = { [weak self] id in
            guard let strongSelf = self else { return }
            strongSelf.presenter.openDetails(by: id)
        }
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
