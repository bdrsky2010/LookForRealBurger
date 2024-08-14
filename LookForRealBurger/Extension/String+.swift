//
//  String+.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/14/24.
//

import Foundation

// MARK: Language Localization
extension String {
    var localized: Self {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(_ arguments: any CVarArg...) -> Self {
        return String(format: self.localized, arguments)
    }
}
