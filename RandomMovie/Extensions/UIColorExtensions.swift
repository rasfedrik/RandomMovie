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
    static var lightYellow: UIColor {
        return UIColor(red: 255, green: 255, blue: 224)
    }
}

extension UIColor {
    static var cornsilk: UIColor {
        return UIColor(red: 255, green: 248, blue: 220)
    }
}

extension UIColor {
    static var blanchedAlmond: UIColor {
        return UIColor(red: 255, green: 235, blue: 205)
    }
}

extension UIColor {
    static var bisque: UIColor {
        return UIColor(red: 255, green: 228, blue: 196)
    }
}

extension UIColor {
    static var complementaryCornsilk: UIColor {
        return UIColor(red: 0, green: 7, blue: 35)
    }
}

extension UIColor {
    static var aestheticComplementaryCornsilk: UIColor {
        return UIColor(red: 128, green: 0, blue: 128) // Пурпурный (фиолетовый)
    }
}

extension UIColor {
    
    static var analogousCornsilk1: UIColor {
        return UIColor(red: 255, green: 223, blue: 186) // Светло-золотистый
    }
}

extension UIColor {
    static var triadicCornsilk1: UIColor {
        return UIColor(red: 220, green: 255, blue: 248) // Бледно-зелёный
    }
}

