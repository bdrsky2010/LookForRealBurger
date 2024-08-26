//
//  AppAppearance.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/19/24.
//

import UIKit

enum AppAppearance {
    static func setupAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = R.Color.background
        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: R.Font.chab20,
            NSAttributedString.Key.foregroundColor: R.Color.brown
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
