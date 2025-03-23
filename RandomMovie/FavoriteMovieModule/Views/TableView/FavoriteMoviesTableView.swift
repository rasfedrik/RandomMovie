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
    
    // MARK: - Methods
    private func setupTableView() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: topAnchor),
            leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        dataSource = self
        delegate = self
        
        register(FavoriteMoviesTableViewCell.self, forCellReuseIdentifier: FavoriteMoviesTableViewCell.id)
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
            withIdentifier: FavoriteMoviesTableViewCell.id,
            for: indexPath) as? FavoriteMoviesTableViewCell
        else { return UITableViewCell() }
        
        let movie = favoriteMoviesPreviewsData[indexPath.row]
        
        let poster = movie.getPosterImage() ?? UIImage(named: "placeholder")
        let name = movie.name ?? "-"
        let alternativeName = movie.alternativeName ?? "-"
        let rating = movie.rating?.kp ?? 0.0
        
        cell.configure(poster: poster, name: name, alternativeName: alternativeName, rating: "\(rating)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
