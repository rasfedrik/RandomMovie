//
//  MovieWinnerView.swift
//  RandomMovie
//
//  Created by Семён Беляков on 06.04.2025.
//

import UIKit

final class MovieWinnerView: UIView {
    
    // MARK: - UI Elements
    private let movieNameLabel: BaseLabel = {
        let label = BaseLabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "questionmark"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let closeButton = BaseButton(type: .closeButton)
    
    var onTap: (() -> Void)?
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraints()
        setupLayer()
        closeButton.onTap = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.isHidden = true
            strongSelf.onTap?()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addGradient()
    }
    
    // MARK: - Configure
    func configure(moviePreview: MoviePreviewModel) {
        self.posterImageView.image = moviePreview.getPosterImage()
        self.movieNameLabel.text = moviePreview.name
    }
    
    // MARK: - Setup UI
    private func setupLayer() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.shadowRadius = 10
        layer.shadowColor = UIColor.mainButtonsColor.cgColor
        layer.shadowOffset = CGSize(width: -10, height: -10)
        layer.masksToBounds = true
        isHidden = true
        posterImageView.layer.cornerRadius = 10
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.6).cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)

        let height: CGFloat = 100
        gradientLayer.frame = CGRect(
            x: 0,
            y: posterImageView.bounds.height - height,
            width: posterImageView.bounds.width,
            height: height
        )

        posterImageView.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        posterImageView.layer.addSublayer(gradientLayer)
    }
    
    // MARK: - Constraints
    private func constraints() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(posterImageView)
        addSubview(movieNameLabel)
        addSubview(closeButton)
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            posterImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            posterImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
            movieNameLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor),
            movieNameLabel.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor),
            movieNameLabel.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor),
            
            closeButton.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 20),
            closeButton.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor),
            closeButton.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor),
            closeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
