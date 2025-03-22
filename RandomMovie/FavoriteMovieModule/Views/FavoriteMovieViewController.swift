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
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavoriteMoviesIDFromUserDefaults()
        setupUI()
    }
    
    
    // MARK: - Methods
    private func loadFavoriteMoviesIDFromUserDefaults() {
        let decoder = JSONDecoder()
        if let savedMovieIdData = UserDefaults.standard.data(forKey: "favoriteMovieIDs"),
            let savedMovieId = try? decoder.decode([FavoriteMovieModel].self, from: savedMovieIdData) {
            print(savedMovieId)
            
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
