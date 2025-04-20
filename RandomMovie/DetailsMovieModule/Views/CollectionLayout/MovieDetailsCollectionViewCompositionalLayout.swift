//
//  MovieDetailsCollectionViewCompositionalLayout.swift
//  RandomMovie
//
//  Created by Семён Беляков on 14.04.2025.
//

import UIKit

enum MovieDetailsCollectionViewCompositionalLayout {
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            
            switch MovieDetailSection(rawValue: sectionIndex) {
            case .poster:
                return createPosterSection()
//            case .title:
//                return createTitleSection()
//            case .actors:
//                return createHorizontalScrollSection(height: 180, header: "Актёры")
//            case .facts:
//                return createHorizontalScrollSection(height: 120, header: "Интересные факты")
//            case .frames:
//                return createFramesSection()
            case .none:
                return nil
            }
        }
    }
    
    private static func createPosterSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(400)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(400)
        )
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
//        section.visibleItemsInvalidationHandler = { items, contentOffset, _ in
//            let offsetY = contentOffset.y
//            items.first?.transform = CGAffineTransform(translationX: 0, y: offsetY * 0.5)
//            items.first?.alpha = max(1 - (offsetY / 200), 0)
//        }
        return section
    }
    
//    private static func createTitleSection() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1),
//            heightDimension: .estimated(60)
//        )
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(0.2))
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//        
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 24, trailing: 16)
//        
//        return section
//    }
//    
//    private static func createHorizontalScrollSection(height: CGFloat, header: String) -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1),
//            heightDimension: .estimated(60)
//        )
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
//        
//        let groupSize = NSCollectionLayoutSize(
//            widthDimension: .absolute(150),
//            heightDimension: .absolute(height)
//        )
//        
//        let group = NSCollectionLayoutGroup.horizontal(
//            layoutSize: groupSize,
//            subitems: [item]
//        )
//        
//        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .continuous
//        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 24, trailing: 16)
//        
//        let headerSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1),
//            heightDimension: .estimated(60)
//        )
//        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: header, alignment: .top)
//        
//        section.boundarySupplementaryItems = [header]
//        
//        return section
//    }
    
    
}

