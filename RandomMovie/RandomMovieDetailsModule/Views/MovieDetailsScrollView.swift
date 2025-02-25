//
//  MovieDetailsScrollView.swift
//  RandomMovie
//
//  Created by Семён Беляков on 15.02.2025.
//

import UIKit

final class MovieDetailsScrollView: UIScrollView {
    
    private let imageLoader = ImageLoader.share
    
    // MARK: - Elements
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Constraints
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.addSubview(posterImageView)
        contentView.addSubview(movieNameLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor),
            
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 450),
            
            movieNameLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor),
            movieNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            movieNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            descriptionLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(posterImage: UIImage?, movieName: String?, description: String?) {
        
        self.posterImageView.image = posterImage ?? UIImage(named: "placeholder")
        self.movieNameLabel.text = movieName
        self.descriptionLabel.text = description
    }
    
}
