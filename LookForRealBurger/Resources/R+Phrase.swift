//
//  R+Phrase.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/19/24.
//

import Foundation

extension R {
    enum Phrase { }
}

extension R.Phrase {
    static let emailPlaceholder = "emailPlaceholder".localized
    static let passwordPlaceholder = "passwordPlaceholder".localized
    static let nickPlaceholder = "nickPlaceholder".localized
    
    static let errorOccurred = "errorOccurred".localized
    static let networkUnstable = "networkUnstable".localized
    
    static func getCongratulation(nick: String) -> String {
        return "congratulation".localized(nick)
    }
}
