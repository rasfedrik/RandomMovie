//
//  SectionHeaderView.swift
//  RandomMovie
//
//  Created by Семён Беляков on 22.04.2025.
//

import UIKit

final class SectionHeaderView: UICollectionReusableView {
    
    // MARK: - Identifier
    static let identifier = "SectionHeaderView"
    
    // MARK: - Properties
    var onShowAllTap: (() -> Void)?
    
    // MARK: - UI Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let showAllButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Все", for: .normal)
        button.setTitleColor(.mainButtonsColor, for: .normal)
        return button
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        showAllButton.addTarget(self, action: #selector(showAllInfoButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    @objc private func showAllInfoButtonTapped() {
        onShowAllTap?()
    }
    
    // MARK: - Constraints
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(showAllButton)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            showAllButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            showAllButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            showAllButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
