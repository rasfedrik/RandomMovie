//
//  MovieDetailsCollectionViewCompositionalLayout.swift
//  RandomMovie
//
//  Created by Семён Беляков on 14.04.2025.
//

import UIKit

enum MovieDetailsCollectionViewCompositionalLayout {
    
    // MARK: - Create Layout
    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            
            switch MovieDetailSection(rawValue: sectionIndex) {
            case .poster:
                return createPosterSection()
            case .title:
                return createTitleSection()
            case .description:
                return createDescriptionSection()
            case .ratings:
                return createRatingsSection()
            case .persons:
                return createHorizontalScrollSection(height: 180)
                //           case .facts:
                //                return createHorizontalScrollSection(height: 120)
                //            case .frames:
                //                return createFramesSection()
            case .none:
                return nil
            }
        }
    }
    
    // MARK: - Create Sections
    private static func createPosterSection() -> NSCollectionLayoutSection {
        let item = createItem(width: .fractionalWidth(1.0), height: .absolute(400))
        let group = createGroup(width: .fractionalWidth(1.0), height: .absolute(400), item: item)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private static func createTitleSection() -> NSCollectionLayoutSection {
        let item = createItem(width: .fractionalWidth(1.0), height: .estimated(30))
        let group = createGroup(width: .fractionalWidth(1.0), height: .estimated(60), item: item)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 14, trailing: 0)
        return section
    }
    
    private static func createRatingsSection() -> NSCollectionLayoutSection {
        let item = createItem(width: .fractionalWidth(1.0), height: .estimated(30))
        let group = createGroup(width: .fractionalWidth(1.0), height: .estimated(60), item: item)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 14, trailing: 0)
        return section
    }
    
    private static func createDescriptionSection() -> NSCollectionLayoutSection {
        let item = createItem(width: .fractionalWidth(1.0), height: .absolute(70))
        let group = createGroup(width: .fractionalWidth(1.0), height: .absolute(70), item: item)
        
        let section = NSCollectionLayoutSection(group: group)
        let header = NSCollectionLayoutBoundarySupplementaryItem.sectionHeader()
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    private static func createHorizontalScrollSection(height: CGFloat) -> NSCollectionLayoutSection {
        let item = createItem(width: .fractionalWidth(1.0), height: .fractionalHeight(1.0))
        let group = createGroup(width: .absolute(150), height: .absolute(height), item: item)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        let header = NSCollectionLayoutBoundarySupplementaryItem.sectionHeader()
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 25, trailing: 0)
        return section
    }
}

    // MARK: - Extension
extension MovieDetailsCollectionViewCompositionalLayout {
    
    private static func createItem(width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension) -> NSCollectionLayoutItem {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        return item
    }
    
    private static func createGroup(width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, item: NSCollectionLayoutItem) -> NSCollectionLayoutGroup {
        
        let groupSize = NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        return group
    }
}
