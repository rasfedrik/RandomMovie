//
//  PosterCell.swift
//  RandomMovie
//
//  Created by Семён Беляков on 14.04.2025.
//

import UIKit

final class PosterCell: UICollectionViewCell, CustomCompositionLayoutCellProtocol {
    
    // MARK: - Properties
    var onTapFavoriteButton: ((Int) -> Void)?
    
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
        favorite.setImage(UIImage(systemName: "star.fill"), for: .normal)
        return favorite
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }
    
    // MARK: - Initializer
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
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.favoriteButton.transform = CGAffineTransform(scaleX: 2, y: 2)
            strongSelf.favoriteButton.transform = .identity
        }
    }
    
    // MARK: - Constraints
    private func setupUI() {
        contentView.addSubview(posterImageView)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: - Configure
    func configure(with model: MovieDetailsModel?) {
        guard let model = model else { return }
        posterImageView.image = model.getPoster(data: model.posterData) ?? UIImage(named: "placeholder")
    }
}
