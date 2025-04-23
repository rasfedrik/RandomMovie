//
//  CollectionLayoutExtensions.swift
//  RandomMovie
//
//  Created by Семён Беляков on 21.04.2025.
//

import UIKit

extension NSCollectionLayoutBoundarySupplementaryItem {
    
    static func sectionHeader(
    ) -> NSCollectionLayoutBoundarySupplementaryItem {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        return .init(layoutSize: size, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
}

extension UICollectionView {
    func register<T: UICollectionViewCell & CustomCompositionLayoutCellProtocol>(_ cellType: T.Type) {
        self.register(cellType, forCellWithReuseIdentifier: cellType.identifier)
    }
}
