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
    var randomMovies: [MoviePreviewModel?] = []
    
    // MARK: - Constants
    private let lineSpacing: CGFloat = 5
    private let interItemSpacing: CGFloat = 5
    private let horizontalInsets: CGFloat = 5
    
    var onTap: ((Int?) -> Void)?
    var isFavorite: ((Int) -> Void)?
    
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
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let widthCell = (frame.size.width - interItemSpacing * 2 - horizontalInsets * 2) / 3
        let heightCell = widthCell * 1.5
        layout.itemSize = CGSize(width: widthCell, height: heightCell)
    }
    
}

extension RandomMoviesViewWithCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return randomMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RandomCollectionViewCell.id,
            for: indexPath) as? RandomCollectionViewCell
        else { return UICollectionViewCell() }
        
        if let movie = randomMovies[indexPath.item] {
            let movieId = movie.id ?? 0
            
            cell.configure(
                with: movie.getPosterImage() ?? UIImage(named: "placeholder"),
                text: movie.name ?? movie.alternativeName,
                movieID: movieId,
                isFavorite: FavoriteService().isFavorite(movieId: movieId)
            )
            
            cell.favoriteMovieTapped = { [weak self] id in
                self?.isFavorite?(id)
            }
            
        }
        return cell
    }
    
}

extension RandomMoviesViewWithCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let posterData = randomMovies[indexPath.row]
        guard let movieId = posterData?.id else { return }
        self.onTap?(movieId)
    }
}

