//
//  UIColorExtensions.swift
//  RandomMovie
//
//  Created by Семён Беляков on 26.01.2025.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha
        )
    }
}

extension UIColor {
    /// Turquoise
    static var mainButtonsColor: UIColor {
        return UIColor(red: 48, green: 213, blue: 200)
    }
}

extension UIColor {
    static var mainButtonsColorAfterTapped: UIColor {
        return UIColor(red: 48, green: 213, blue: 200, alpha: 0.3)
    }
}

