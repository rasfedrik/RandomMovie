//
//  TitleCell.swift
//  RandomMovie
//
//  Created by Семён Беляков on 20.04.2025.
//

import UIKit

final class TitleCell: UICollectionViewCell, CustomCompositionLayoutCellProtocol {
    
    // MARK: - UI Elements
    private let movieNameLabel: BaseLabel = {
        let label = BaseLabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let movieAlternativeNameLabel: BaseLabel = {
        let label = BaseLabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Constraints
    private func setupUI() {
        contentView.addSubview(movieNameLabel)
        contentView.addSubview(movieAlternativeNameLabel)
        
        NSLayoutConstraint.activate([
            movieNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            movieAlternativeNameLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 3),
            movieAlternativeNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieAlternativeNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieAlternativeNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: - Configure
    func configure(with model: MovieDetailsModel?) {
        guard let model = model else { return }
        let name = model.name ?? "-"
        let alternativeName = model.alternativeName ?? ""
        let year = model.year ?? 0
        
        movieNameLabel.text = "\(name)"
        movieAlternativeNameLabel.text = year == 0 ? "\(alternativeName)" : "\(alternativeName) (\(year))"
    }
}
