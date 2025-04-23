//
//  CustomCompositionLayoutCellProtocol.swift
//  RandomMovie
//
//  Created by Семён Беляков on 21.04.2025.
//

import UIKit

protocol CustomCompositionLayoutCellProtocol {
    static var identifier: String { get }
}

extension CustomCompositionLayoutCellProtocol {
    static var identifier: String {
        String(describing: Self.self)
    }
}
