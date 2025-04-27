//
//  TitleCell.swift
//  RandomMovie
//
//  Created by Семён Беляков on 20.04.2025.
//

import UIKit

final class TitleCell: UICollectionViewCell, CustomCompositionLayoutCellProtocol {
    
    // MARK: - UI Elements
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()
    
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
    
    private let countryNameLabel: BaseLabel = {
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
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(movieNameLabel)
        stackView.addArrangedSubview(movieAlternativeNameLabel)
        stackView.addArrangedSubview(countryNameLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: - Configure
    func configure(with model: MovieDetailsModel?) {
        guard let model = model else { return }
        let name = model.name ?? "-"
        let alternativeName = model.alternativeName ?? ""
        let year = model.year ?? 0
        
        movieNameLabel.text = name
        movieAlternativeNameLabel.text = alternativeName
        
        guard let countries = model.countries else { return }
        var countriesNames = ""
        for (index, country) in countries.enumerated() {
            let country = country.name ?? ""
            let countriesLastIndex = countries.count - 1
            countriesNames += countriesLastIndex != index ? "\(country), " : country
        }
        countryNameLabel.text = year == 0 ? countriesNames : "\(countriesNames) (\(year))"
    }
}
