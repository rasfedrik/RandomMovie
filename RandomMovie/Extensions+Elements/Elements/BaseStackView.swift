//
//  BaseStackView.swift
//  RandomMovie
//
//  Created by Семён Беляков on 07.03.2025.
//

import UIKit

final class BaseStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        spacing = 10
        alignment = .fill
        distribution = .fillEqually
        axis = .horizontal
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
