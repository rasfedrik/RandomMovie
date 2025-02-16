//
//  RandomButton.swift
//  RandomMovie
//
//  Created by Семён Беляков on 19.01.2025.
//

import UIKit

final class RandomButton: UIButton {
    
    private var shadowLayer: CAShapeLayer!
    
    //MARK: - TypeButtons
    enum TypeButtons {
        case randomMovie
        case startOver
    }
    
    //MARK: - init
    init(type button: TypeButtons) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupLayer()
        self.configuration = configuration(button: button)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configuration = configuration(button: .randomMovie)
    }
    
    
    
    // MARK: - Button Configuration
    private func configuration(button type: TypeButtons) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .analogousCornsilk1
        configuration.baseForegroundColor = .aestheticComplementaryCornsilk
        configuration.cornerStyle = .capsule
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
        
        switch type {
        case .randomMovie:
            configuration.title = "Cлучайный фильм"
            
        case .startOver:
            configuration.title = "Начать сначала"
        }
        
        return configuration
    }
    
    private func setupLayer() {
        layer.cornerRadius = 30
        layer.cornerCurve = .continuous
        layer.shadowOpacity = 0.2
        layer.shadowColor = UIColor.aestheticComplementaryCornsilk.cgColor
        layer.shadowOffset = .init(width: .zero, height: 8)
        layer.shadowRadius = 10
    }
}
