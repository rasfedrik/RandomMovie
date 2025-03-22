//
//  RandomMoviesCollectionView.swift
//  RandomMovie
//
//  Created by Семён Беляков on 22.01.2025.
//

import UIKit

final class RandomMoviesViewWithCollectionView: UIView {
    
    // MARK: - Properties
    private(set) var collectionView: UICollectionView!
    
    // MARK: - Constants
    private let lineSpacing: CGFloat = 5
    private let interItemSpacing: CGFloat = 5
    private let horizontalInsets: CGFloat = 5
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Collection View
    private func configureCollectionView() {
        translatesAutoresizingMaskIntoConstraints = false

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: horizontalInsets, bottom: 0, right: horizontalInsets)
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = interItemSpacing
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .none
        
        collectionView.register(RandomCollectionViewCell.self,
                                forCellWithReuseIdentifier: RandomCollectionViewCell.id)
        
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let widthCell = (frame.size.width - interItemSpacing * 2 - horizontalInsets * 2) / 3
        let heightCell = widthCell * 1.5
        layout.itemSize = CGSize(width: widthCell, height: heightCell)
    }
    
}
