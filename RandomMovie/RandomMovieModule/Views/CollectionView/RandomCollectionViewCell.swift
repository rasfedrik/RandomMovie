//
//  RandomCollectionViewCell.swift
//  RandomMovie
//
//  Created by Семён Беляков on 22.01.2025.
//

import UIKit

final class RandomCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Identifier
    static let id = "CollectionViewCell"
    
    // MARK: - Elements
    private var movieNameLabel: BaseLabel = {
        let label = BaseLabel()
        label.textAlignment = .center
        return label
    }()
    
    private var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var starImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Constrains
    private func setupElements() {
        addSubview(posterImageView)
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            posterImageView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
        
        addSubview(movieNameLabel)
        NSLayoutConstraint.activate([
            movieNameLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 2),
            movieNameLabel.widthAnchor.constraint(equalTo: widthAnchor),
            movieNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        addSubview(starImageView)
        NSLayoutConstraint.activate([
            starImageView.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: 5),
            starImageView.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: -5),
            starImageView.widthAnchor.constraint(equalToConstant: 30),
            starImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    func configure(with poster: UIImage?, text: String?) {
        self.posterImageView.image = poster
        self.movieNameLabel.text = text
    }
    
}
