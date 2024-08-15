//
//  AccessTokenStorage.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/15/24.
//

import Foundation

enum TokenType {
    case access
    case refresh
}

protocol AccessTokenStorage {
    func fetchToken(for tokenType: TokenType) -> String
    func saveToken(for tokenType: TokenType, with token: String)
    func removeToken()
}
