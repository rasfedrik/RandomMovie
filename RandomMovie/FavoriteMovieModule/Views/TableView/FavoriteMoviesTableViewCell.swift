//
//  FavoriteMoviesTableViewCell.swift
//  RandomMovie
//
//  Created by Семён Беляков on 22.03.2025.
//

import UIKit

final class FavoriteMoviesTableViewCell: UITableViewCell {
    
    // MARK: - Identifier
    static let id = "CustomTableViewCell"
    
    // MARK: - UI Elements
    private var posterImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "questionmark"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var movieNameLabel: BaseLabel = {
        let label = BaseLabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private var movieAlternativeNameLabel: BaseLabel = {
        let label = BaseLabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private var ratingLabel: BaseLabel = {
        let label = BaseLabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()

    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = .mainButtonsColorAfterTapped
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        addSubview(posterImageView)
        addSubview(movieNameLabel)
        addSubview(movieAlternativeNameLabel)
        addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            posterImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            
            movieNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            movieNameLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 5),
            movieNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            movieAlternativeNameLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 2),
            movieAlternativeNameLabel.leadingAnchor.constraint(equalTo: movieNameLabel.leadingAnchor),
            movieAlternativeNameLabel.trailingAnchor.constraint(equalTo: movieNameLabel.trailingAnchor),
            
            ratingLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            ratingLabel.leadingAnchor.constraint(equalTo: movieNameLabel.leadingAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: movieNameLabel.trailingAnchor)

        ])
    }
    
    // MARK: - Configure
    func configure(poster: UIImage?, name: String?, alternativeName: String?, rating: String?) {
        self.posterImageView.image = poster
        self.movieNameLabel.text = name
        self.movieAlternativeNameLabel.text = alternativeName
        self.ratingLabel.text = rating
    }
    
}
