//
//  MovieContentView.swift
//  RandomMovie
//
//  Created by Семён Беляков on 17.04.2025.
//

import UIKit

final class MovieContentView: UIView {

    typealias MovieDataSource = UICollectionViewDiffableDataSource<MovieDetailSection, AnyHashable>
    
    // MARK: - Properties
    private var dataSource: MovieDataSource!
    private(set) var collectionView: UICollectionView!
    private var snapShot = NSDiffableDataSourceSnapshot<MovieDetailSection, AnyHashable>()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionView()
        configureDataSource()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: MovieDetailsCollectionViewCompositionalLayout.createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MovieDetailsPosterCell.self, forCellWithReuseIdentifier: MovieDetailsPosterCell.identifier)
        
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureDataSource() {
        dataSource = MovieDataSource(collectionView: collectionView) { (collectionView, indexPath, item) -> MovieDetailsPosterCell? in
            
            switch MovieDetailSection(rawValue: indexPath.section) {
            case .poster:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieDetailsPosterCell.identifier, for: indexPath) as! MovieDetailsPosterCell
                
                if let movie = item as? MovieDetailsModel {
                cell.configure(with: item as? MovieDetailsModel)
                }
                
                return cell
            default:
                return nil
            }
        }
    }
    
    func applySnapShot(movie: MovieDetailsModel?) {

        guard let movie = movie else {
            print("Failed applySnapShot: movie == nil")
            return
        }
        snapShot.appendSections([.poster])
        snapShot.appendItems([movie], toSection: .poster)
        dataSource.apply(snapShot, animatingDifferences: true)
    }
}
