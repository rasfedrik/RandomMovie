//
//  RandomButton.swift
//  RandomMovie
//
//  Created by Семён Беляков on 19.01.2025.
//

import UIKit

final class RandomButton: UIButton {
    
    //MARK: - TypeButton
    enum TypeButton {
        case randomMovie
    }
    
    //MARK: - init
    init(type button: TypeButton) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.configuration = configuration(button: button)
//        self.buttonTapped(type: button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Button Configuration
    private func configuration(button type: TypeButton) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        
        configuration.baseForegroundColor = .black
        
        switch type {
        case .randomMovie:
            configuration.title = "Cлучайный фильм"
        }
        
        return configuration
    }
    
}
