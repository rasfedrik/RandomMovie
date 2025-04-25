//
//  AllActorsTableViewCell.swift
//  RandomMovie
//
//  Created by Семён Беляков on 23.04.2025.
//

import UIKit

final class AllActorsTableViewCell: UITableViewCell {
    // MARK: - Identifier
    static let identifier = "AllActorsTableViewCell"
    
    // MARK: - UI Elements
    private var photoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "questionmark"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var nameLabel: BaseLabel = {
        let label = BaseLabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private var charactersNameLabel: BaseLabel = {
        let label = BaseLabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(charactersNameLabel)
        
        NSLayoutConstraint.activate([
            photoImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            charactersNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            charactersNameLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 5),
            charactersNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    // MARK: - Configure
    func configure(person: MovieDetailsModel.Person?) {
        guard let person = person else { return }
        nameLabel.text = person.name
        charactersNameLabel.text = person.description
        let data = person.personPhotoData
        photoImageView.image = person.getPhoto(data: data)
    }
    
}
