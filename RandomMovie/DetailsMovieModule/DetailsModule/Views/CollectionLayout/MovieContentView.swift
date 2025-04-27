//
//  MovieContentView.swift
//  RandomMovie
//
//  Created by Семён Беляков on 17.04.2025.
//

import UIKit

final class MovieContentView: UIView {
    
    private typealias MovieDataSource = UICollectionViewDiffableDataSource<MovieDetailSection, AnyHashable>
    private typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<MovieDetailSection, AnyHashable>
    
    // MARK: - Properties
    private var dataSource: MovieDataSource!
    private var collectionView: UICollectionView!
    private var snapshot = DataSourceSnapshot()
    private var currentMovie: MovieDetailsModel?
    
    var onTap: ((Int) -> Void)?
    var showAllInfoOnTap: ((MovieDetailSection) -> Void)?
    
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
        // implementation in CollectionLayoutExtensions + CustomCompositionLayoutCellProtocol
        collectionView.register(PosterCell.self)
        collectionView.register(TitleCell.self)
        collectionView.register(RatingCell.self)
        collectionView.register(DescriptionCell.self)
        collectionView.register(PersonCell.self)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
        
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureDataSource() {
        dataSource = MovieDataSource(collectionView: collectionView) { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            guard let strongSelf = self else { return UICollectionViewCell() }
            switch MovieDetailSection(rawValue: indexPath.section) {
            case .poster:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCell.identifier, for: indexPath) as! PosterCell
                
                if let movie = strongSelf.currentMovie {
                    cell.configure(with: movie)
                    return cell
                }
                
            case .title:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCell.identifier, for: indexPath) as! TitleCell
                
                if let movie = strongSelf.currentMovie {
                    cell.configure(with: movie)
                    return cell
                }
                return cell
                
            case .ratings:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RatingCell.identifier, for: indexPath) as! RatingCell
                
                if let movie = strongSelf.currentMovie {
                    cell.configure(with: movie)
                    cell.onTapFavoriteButton = { [weak self] id in
                        guard let strongSelf = self else { return }
                        strongSelf.onTap?(id)
                    }
                    return cell
                }
                return cell
                
            case .description:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DescriptionCell.identifier, for: indexPath) as! DescriptionCell
                
                if let movie = strongSelf.currentMovie {
                    cell.configure(with: movie)
                    return cell
                }
                
            case .persons:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonCell.identifier, for: indexPath) as! PersonCell
                if let person = item as? MovieDetailsModel.Person {
                    cell.configure(with: person)
                }
                return cell
                
            case .none:
                return nil
            }
            return UICollectionViewCell()
        }
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView in
            guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as! SectionHeaderView
            
            if let section = MovieDetailSection(rawValue: indexPath.section) {
                header.titleLabel.text = section.title
                header.onShowAllTap = { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.showAllInfoOnTap?(section)
                }
            }
            return header
        }
    }
    
    func applySnapshot(movie: MovieDetailsModel?) {
        guard let movie = movie else {
            print("Failed applySnapShot: movie == nil")
            return
        }
        self.currentMovie = movie
        
        snapshot.appendSections(MovieDetailSection.allCases)
        snapshot.appendItems([PosterItem.poster(movie: movie)], toSection: .poster)
        snapshot.appendItems([TitleItem.title(movie: movie)], toSection: .title)
        snapshot.appendItems([RatingsItem.ratings(movie: movie)], toSection: .ratings)
        snapshot.appendItems([DescriptionItem.description(movie: movie)], toSection: .description)
        if let persons = movie.persons {
            let uniquePersons = Array(Set(persons))
            snapshot.appendItems(uniquePersons, toSection: .persons)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
