//
//  RandomButton.swift
//  RandomMovie
//
//  Created by Семён Беляков on 19.01.2025.
//

import UIKit

final class RandomButton: UIButton {
    
    private var gradientLayer = CAGradientLayer()
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
        self.configuration = configuration(button: button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if layer == self.layer {
            gradientLayer.frame = bounds
            gradientLayer.cornerRadius = layer.cornerRadius
        }
    }
    
    // MARK: - Button Configuration
    private func configuration(button type: TypeButtons) -> UIButton.Configuration {
        
        layer.cornerRadius = 30
        
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .analogousCornsilk1
        configuration.baseForegroundColor = .aestheticComplementaryCornsilk
        configuration.cornerStyle = .capsule
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer({ incoming in
            var outgoing = incoming
            outgoing.font = UIFont.preferredFont(forTextStyle: .callout)
            return outgoing
        })
        
//        layer.borderWidth = 0.5
//        layer.borderColor = UIColor.cornsilk.cgColor
        layer.cornerCurve = .continuous
        layer.shadowOpacity = 0.2
        layer.shadowColor = UIColor.aestheticComplementaryCornsilk.cgColor
        layer.shadowOffset = .init(width: .zero, height: 8)
        layer.shadowRadius = 10
        
        configurationUpdateHandler = { button in
            if button.isHighlighted {
                UIView.animate(withDuration: 0.1) {
                    button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                }
            } else {
                UIView.animate(withDuration: 0.1) {
                    button.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
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
}
