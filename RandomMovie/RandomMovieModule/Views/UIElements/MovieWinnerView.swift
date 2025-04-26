//
//  MovieWinnerView.swift
//  RandomMovie
//
//  Created by Семён Беляков on 06.04.2025.
//

import UIKit

final class MovieWinnerView: UIView {
    
    // MARK: - UI Elements
    private let posterImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "questionmark"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.tintColor = .yellow
        return imageView
    }()
    
    private let movieNameLabel: BaseLabel = {
        let label = BaseLabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    private let movieAlternativeNameLabel: BaseLabel = {
        let label = BaseLabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let closeButton = BaseButton(type: .closeButton)
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    private let namesStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        
        return stack
    }()
    
    var onTapCloseButton: (() -> Void)?
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func setupView() {
        clipsToBounds = true
        backgroundColor = .white
        layer.cornerRadius = 10
        
        addSubview(stackView)
        addSubview(closeButton)
        
        namesStackView.addArrangedSubview(movieNameLabel)
        namesStackView.addArrangedSubview(movieAlternativeNameLabel)
        
        stackView.addArrangedSubview(posterImageView)
        stackView.addArrangedSubview(namesStackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            posterImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            closeButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 5),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            closeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    private func setupActions() {
        closeButton.onTap = { [weak self] in
            guard let self = self else { return }
            self.isHidden = true
            self.onTapCloseButton?()
        }
    }
    
    // MARK: - Configure
    func configure(with model: MoviePreviewModel?) {
        guard let model = model else { return }
        posterImageView.image = model.getPosterImage()
        movieNameLabel.text = model.name ?? "-"
        
        let year = model.year ?? 0
        let alternativeName = model.alternativeName ?? ""
        movieAlternativeNameLabel.text = year == 0 ? "\(alternativeName)" : "\(alternativeName) (\(year))"
    }
}
