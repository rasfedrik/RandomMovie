//
//  PersonCell.swift
//  RandomMovie
//
//  Created by Семён Беляков on 21.04.2025.
//

import UIKit

final class PersonCell: UICollectionViewCell, CustomCompositionLayoutCellProtocol {
    
    // MARK: - UI Elements
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let actorNameLabel: BaseLabel = {
        let label = BaseLabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
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
        contentView.addSubview(photoImageView)
        contentView.addSubview(actorNameLabel)
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            photoImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            
            actorNameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 0),
            actorNameLabel.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor),
            actorNameLabel.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor),
            actorNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }
    
    // MARK: - Configure
    func configure(with person: MovieDetailsModel.Person?) {
        guard let person = person else { return }
        self.actorNameLabel.text = person.name
        self.photoImageView.image = person.getPhoto(data: person.personPhotoData)
    }
}
