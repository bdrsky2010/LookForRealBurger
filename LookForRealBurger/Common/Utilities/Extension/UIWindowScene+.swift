//
//  UIWindowScene+.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/26/24.
//

import UIKit

extension UIWindowScene {
    static var deviceWidth: CGFloat? {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let width = windowScene.screen.bounds.width
            return width
        } else {
            return nil
        }
    }
    
    static var deviceHeight: CGFloat? {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let height = windowScene.screen.bounds.height
            return height
        } else {
            return nil
        }
    }
    
    static var isSmallDevice: Bool {
        if let deviceWidth, deviceWidth <= 375 {
            return true
        } else {
            return false
        }
    }
}
