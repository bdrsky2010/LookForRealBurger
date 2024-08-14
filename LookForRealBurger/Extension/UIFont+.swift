//
//  UIFont+.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/14/24.
//

import UIKit

// MARK: Custom Font chap
extension UIFont {
    static func chap(size fontSize: CGFloat) -> UIFont {
        let familyName = "chab"
        return UIFont(name: familyName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .black)
    }
}

// MARK: Custom Font pretendard
extension UIFont {
    static func pretendard(size fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        
        let familyName = "Pretendard"
        var weightString: String
        
        switch weight {
        case .black:
            weightString = "Black"
        case .bold:
            weightString = "Blod"
        case .heavy:
            weightString = "ExtraBold"
        case .ultraLight:
            weightString = "ExtraLight"
        case .light:
            weightString = "Light"
        case .medium:
            weightString = "Medium"
        case .regular:
            weightString = "Regular"
        case .semibold:
            weightString = "SemiBold"
        case .thin:
            weightString = "Thin"
        default:
            weightString = "Regular"
        }

        return UIFont(name: "\(familyName)-\(weightString)", size: fontSize) ?? .systemFont(ofSize: fontSize, weight: weight)
    }
}
