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
    private var movieNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .aestheticComplementaryCornsilk
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .analogousCornsilk1
        setupImageView()
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Constrains
    private func setupImageView() {
        addSubview(posterImageView)
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor),
            posterImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            posterImageView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }
    
    private func setupLabel() {
        addSubview(movieNameLabel)
        NSLayoutConstraint.activate([
            movieNameLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 2),
            movieNameLabel.widthAnchor.constraint(equalTo: widthAnchor),
            movieNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    
    func configure(with poster: UIImage?, text: String?) {
        self.posterImageView.image = poster
        self.movieNameLabel.text = text
    }
    
}
