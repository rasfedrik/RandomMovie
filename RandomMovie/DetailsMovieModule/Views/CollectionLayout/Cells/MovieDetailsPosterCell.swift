//
//  MovieDetailsPosterCell.swift
//  RandomMovie
//
//  Created by Семён Беляков on 14.04.2025.
//

import UIKit

final class MovieDetailsPosterCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "MovieDetailsPosterCell"
    private var movieID: Int?
    private var isFavorite: Bool = false {
        didSet {
            let starImage = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
            favoriteButton.setImage(starImage, for: .normal)
        }
    }
    var onTap: ((Int) -> Void)?
    
    // MARK: - UI Elements
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
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
        contentView.addSubview(posterImageView)
        contentView.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
                    
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            posterImageView.heightAnchor.constraint(equalToConstant: 450),
                    
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }
    
    // MARK: - Configure
    func configure(with model: MovieDetailsModel?) {
        
        guard let model = model else {
            print("Configure cell failed")
            return
        }
        
        self.movieID = model.id
        posterImageView.image = model.getImage(data: model.posterData)
        self.isFavorite = FavoriteService().isFavorite(movieId: model.id ?? 0)
    }
}
