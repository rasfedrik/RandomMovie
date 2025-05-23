//
//  FavoriteMoviesTableView.swift
//  RandomMovie
//
//  Created by Семён Беляков on 22.03.2025.
//

import UIKit

final class FavoriteMoviesTableView: UITableView {
    
    // MARK: - Properties
    var favoriteMoviesPreviewsData: [MoviePreviewModel] = []
    
    // MARK: - Initializer
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        backgroundColor = .clear
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var onTap: ((Int) -> Void)?
    
    // MARK: - Methods
    private func setupTableView() {
        translatesAutoresizingMaskIntoConstraints = false
        dataSource = self
        delegate = self
        register(FavoriteMoviesTableViewCell.self, forCellReuseIdentifier: FavoriteMoviesTableViewCell.identifier)
    }
    
}

extension FavoriteMoviesTableView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMoviesPreviewsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard indexPath.row < favoriteMoviesPreviewsData.count else {
            return UITableViewCell()
        }
        
        guard let cell = dequeueReusableCell(
            withIdentifier: FavoriteMoviesTableViewCell.identifier,
            for: indexPath) as? FavoriteMoviesTableViewCell
        else { return UITableViewCell() }
        
        let movie = favoriteMoviesPreviewsData[indexPath.row]
        cell.configure(with: movie)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let id = favoriteMoviesPreviewsData[indexPath.row].id else { return }
        onTap?(id)
    }
}
