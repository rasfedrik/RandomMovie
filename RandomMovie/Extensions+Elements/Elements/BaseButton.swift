//
//  BaseButton.swift
//  RandomMovie
//
//  Created by Семён Беляков on 19.01.2025.
//

import UIKit

final class BaseButton: UIButton {
    
    //MARK: - ButtonsType
    enum ButtonsType: String {
        case randomMovie = "Случайный фильм"
        case startOver = "Начать сначала"
        case applyFilters = "Применить"
    }
    
    private var type: ButtonsType
    var onTap: (() -> Void)?
    
    //MARK: - init
    init(type button: ButtonsType) {
        self.type = button
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupLayer()
        self.configuration = configuration(button: button)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Button Configuration
    
    @objc private func buttonTapped() {
        onTap?()
    }
    
    private func setupLayer() {
        layer.cornerRadius = 30
        layer.cornerCurve = .continuous
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .init(width: .zero, height: 8)
        layer.shadowRadius = 10
    }
    
    private func configuration(button type: ButtonsType) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.title = type.rawValue
        configuration.baseBackgroundColor = .mainButtonsColor
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .callout)
            return outgoing
        })
        
        configurationUpdateHandler = { button in
            UIView.animate(withDuration: 0.15) {
                button.transform = button.isHighlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
                button.alpha = button.isHighlighted ? 0.8 : 1
            }
        }
        return configuration
    }
}
