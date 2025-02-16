//
//  BaseLabel.swift
//  RandomMovie
//
//  Created by Семён Беляков on 15.02.2025.
//

import UIKit

class BaseLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        textColor = .aestheticComplementaryCornsilk
        font = UIFont.systemFont(ofSize: 18)
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
