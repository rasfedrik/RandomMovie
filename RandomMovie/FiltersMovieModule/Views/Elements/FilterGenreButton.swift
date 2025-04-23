//
//  FilterGenreButton.swift
//  RandomMovie
//
//  Created by Семён Беляков on 28.02.2025.
//

import UIKit

final class FilterGenreButton: UIButton {
    
    private enum UserDefaultsKeys: String {
        case isFilterTapped = "isFilterTapped"
    }
    
    private var isFilterTapped = false {
        didSet {
            updateAppearance()
        }
    }
    
    // MARK: - ButtonsType
    enum ButtonsType: String, CaseIterable {
        case comedy = "комедия"
        case drama = "драма"
        case horror = "ужасы"
        case melodrama = "мелодрама"
        case triller = "триллер"
        case action = "боевик"
    }
    
    private(set) var type: ButtonsType
    var onTap: ((ButtonsType.RawValue) -> Void)?
    
    // MARK: - Initializer
    init(type button: ButtonsType) {
        self.type = button
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupLayer()
        addTarget(self, action: #selector(genreTapped), for: .touchUpInside)
        self.configuration = configuration(button: button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Button Configurations
    private func setupLayer() {
        layer.cornerRadius = 30
        layer.cornerCurve = .continuous
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .init(width: .zero, height: 8)
        layer.shadowRadius = 10
    }
    
    @objc func genreTapped() {
        isFilterTapped.toggle()
        onTap?(type.rawValue)
    }
    
    private func userDefaultsKey() -> String {
        UserDefaultsKeys.isFilterTapped.rawValue + "\(type)"
    }
    
    private func updateAppearance() {
        configuration?.baseBackgroundColor = isFilterTapped ? .mainButtonsColorAfterTapped : .mainButtonsColor
    }
    
    private func configuration(button type: ButtonsType) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .mainButtonsColor
        configuration.title = type.rawValue
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .callout)
            return outgoing
        })
        
        configurationUpdateHandler = { button in
            UIView.animate(withDuration: 0.15) {
                if self.isFilterTapped {
                    button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                } else {
                    button.transform = button.isHighlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
                }
            }
        }
        return configuration
    }
}

