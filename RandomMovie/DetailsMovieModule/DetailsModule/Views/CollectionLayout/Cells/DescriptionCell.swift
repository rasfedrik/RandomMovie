//
//  DescriptionCell.swift
//  RandomMovie
//
//  Created by Семён Беляков on 21.04.2025.
//

import UIKit

final class DescriptionCell: UICollectionViewCell, CustomCompositionLayoutCellProtocol {
    
    // MARK: - UI Elements
    private let descriptionLabel: BaseLabel = {
        let label = BaseLabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
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
        contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: - Configure
    func configure(with model: MovieDetailsModel?) {
        guard let model = model else { return }
        descriptionLabel.text = model.description
    }
}
