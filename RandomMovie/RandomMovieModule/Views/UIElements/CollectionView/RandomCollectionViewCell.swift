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
    
    // MARK: - Properties
    private var movieID: Int?
    private var isFavorite: Bool = false {
        didSet {
            let starImage = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
            favoriteButton.setImage(starImage, for: .normal)
        }
    }
    
    // MARK: - UI Elements
    private var movieNameLabel: BaseLabel = {
        let label = BaseLabel()
        label.textAlignment = .center
        return label
    }()
    
    private var posterImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "questionmark"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var favoriteButton: UIButton = {
        let favorite = UIButton(type: .roundedRect)
        favorite.translatesAutoresizingMaskIntoConstraints = false
        favorite.tintColor = UIColor.mainButtonsColor
        return favorite
    }()
    
    private var highLightedBorderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.red.cgColor
        view.isHidden = true
        return view
    }()
        
    var favoriteMovieTapped: ((Int) -> Void)?
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        favoriteButton.addTarget(self, action: #selector(starTapped), for: .touchUpInside)
        setupElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieID = nil
        movieNameLabel.text = nil
        posterImageView.image = UIImage(systemName: "questionmark")
    }
    
    // MARK: - Constrains
    private func setupElements() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(movieNameLabel)
        contentView.addSubview(favoriteButton)
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            posterImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            movieNameLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 2),
            movieNameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            movieNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: 5),
            favoriteButton.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: -5),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        contentView.addSubview(highLightedBorderView)
        NSLayoutConstraint.activate([
            highLightedBorderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            highLightedBorderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            highLightedBorderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            highLightedBorderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: - Methods
    @objc private func starTapped() {
        guard let movieID = movieID else { return }
        isFavorite.toggle()
        UIView.animate(withDuration: 0.3) {
            self.favoriteButton.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.favoriteButton.transform = .identity
            self.favoriteMovieTapped?(movieID)
        }
    }
    
    func setHighlight(_ highlight: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.highLightedBorderView.isHidden = !highlight
            self.transform = highlight ? CGAffineTransform(scaleX: 1.05, y: 1.05) : .identity
        }
    }
    
    // MARK: - Configure
    func configure(with model: MoviePreviewModel?) {
        guard let model = model else { return }
        self.posterImageView.image = model.getPosterImage() ?? UIImage(named: "placeholder")
        self.movieNameLabel.text = model.name ?? "-"
        self.movieID = model.id
        self.isFavorite = model.isFavorite
    }
    
}
