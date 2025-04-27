//
//  RatingCell.swift
//  RandomMovie
//
//  Created by Семён Беляков on 22.04.2025.
//

import UIKit

final class RatingCell: UICollectionViewCell, CustomCompositionLayoutCellProtocol {
    
    // MARK: - Properties
    private var movieID: Int?
    private var isFavorite: Bool = false {
        didSet {
            let starImage = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
            favoriteButton.setImage(starImage, for: .normal)
            
            let favoriteText = isFavorite ? "Избранное" : "В избранное"
            favoriteLabel.text = favoriteText
        }
    }
    var onTapFavoriteButton: ((Int) -> Void)?
    
    // MARK: - UI Elements
    private let commonStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        return stack
    }()
    
    private let favoriteStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    private var favoriteButton: UIButton = {
        let favorite = UIButton()
        favorite.tintColor = UIColor.mainButtonsColor
        return favorite
    }()
    
    private var favoriteLabel: BaseLabel = {
        let label = BaseLabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let kPStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    private var ratingKPLabel: BaseLabel = {
        let label = BaseLabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let starKPImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
        imageView.tintColor = .orange
        return imageView
    }()
    
    private let iMdbStackView: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    private var ratingIMDBLabel: BaseLabel = {
        let label = BaseLabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let starImdbImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
        imageView.tintColor = .orange
        return imageView
    }()
    
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
        guard let movieId = movieID else { return }
        isFavorite.toggle()
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.favoriteButton.transform = CGAffineTransform(scaleX: 2, y: 2)
            strongSelf.favoriteButton.transform = .identity
            strongSelf.onTapFavoriteButton?(movieId)
        }
    }

    // MARK: - Constraints
    private func setupUI() {
        contentView.addSubview(commonStackView)
        commonStackView.addArrangedSubview(favoriteStackView)
        commonStackView.addArrangedSubview(kPStackView)
        commonStackView.addArrangedSubview(iMdbStackView)
        
        favoriteStackView.addArrangedSubview(favoriteButton)
        favoriteStackView.addArrangedSubview(favoriteLabel)
        
        kPStackView.addArrangedSubview(starKPImageView)
        kPStackView.addArrangedSubview(ratingKPLabel)
        
        iMdbStackView.addArrangedSubview(starImdbImageView)
        iMdbStackView.addArrangedSubview(ratingIMDBLabel)
        
        NSLayoutConstraint.activate([
            commonStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            commonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            commonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            commonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: - Configure
    func configure(with model: MovieDetailsModel?) {
        guard let model = model else { return }
        self.movieID = model.id
        self.isFavorite = FavoriteService().isFavorite(movieId: model.id ?? 0)
        
        let ratingKp = model.rating?.kp ?? 0
        let ratingImdb = model.rating?.imdb ?? 0
        self.ratingKPLabel.text = "Kinopoisk: \(ratingKp)"
        self.ratingIMDBLabel.text = "IMDb: \(ratingImdb)"
    }
}
