//
//  BaseTextField.swift
//  RandomMovie
//
//  Created by Семён Беляков on 04.03.2025.
//

import UIKit

final class BaseTextField: UITextField {
    
    private let tapGesture = UITapGestureRecognizer()
    var onTap: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        borderStyle = .roundedRect
        textAlignment = .left
        keyboardType = .numberPad
    }
    
}
