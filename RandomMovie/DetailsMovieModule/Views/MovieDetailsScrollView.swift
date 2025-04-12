//
//  MovieDetailsScrollView.swift
//  RandomMovie
//
//  Created by Семён Беляков on 15.02.2025.
//

import UIKit

final class MovieDetailsScrollView: UIScrollView {
    
    // MARK: - Properties
    private let imageLoader = ImageLoader.share
    private var movieID: Int?
    private var isFavorite: Bool = false {
        didSet {
            let starImage = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
            favoriteButton.setImage(starImage, for: .normal)
        }
    }
    var onTap: ((Int) -> Void)?
    
    // MARK: - UI Elements
    private let contentView: UIView = {
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var favoriteButton: UIButton = {
        let favorite = UIButton(type: .roundedRect)
        favorite.translatesAutoresizingMaskIntoConstraints = false
        favorite.tintColor = UIColor.mainButtonsColor
        return favorite
    }()
    
    private let movieNameLabel: BaseLabel = {
        let label = BaseLabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let descriptionLabel = BaseLabel()
    private let genreLabel = BaseLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        favoriteButton.addTarget(self, action: #selector(starTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    @objc private func starTapped() {
        guard let movieId = movieID else { return }
        isFavorite.toggle()
        UIView.animate(withDuration: 0.3) {
            self.onTap?(movieId)
        }
    }
    
    // MARK: - Constraints
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.addSubview(posterImageView)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(movieNameLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor),
            
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            posterImageView.heightAnchor.constraint(equalToConstant: 450),
            
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            movieNameLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            movieNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            movieNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 7),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 7),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: - Configure
    func configure(id: Int, posterImage: UIImage?, movieName: String?, description: String?, isFavorite: Bool) {
        self.movieID = id
        self.posterImageView.image = posterImage ?? UIImage(named: "placeholder")
        self.movieNameLabel.text = movieName
        self.descriptionLabel.text = description
        self.isFavorite = isFavorite
    }
    
}
