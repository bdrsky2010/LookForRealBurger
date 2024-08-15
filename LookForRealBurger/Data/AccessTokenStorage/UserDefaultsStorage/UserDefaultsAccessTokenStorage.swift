//
//  UserDefaultsAccessTokenStorage.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/15/24.
//

import Foundation

final class UserDefaultsAccessTokenStorage {
    static let shared = UserDefaultsAccessTokenStorage()
    
    private let accessTokenKey = "LookForRealBurgerAccess"
    private let refreshTokenKey = "LookForRealBurgerRefresh"
    private let userDefaults: UserDefaults
    
    private init(
        userDefaults: UserDefaults = UserDefaults.standard
    ) {
        self.userDefaults = userDefaults
    }
    
    private func resetUserDefaults() {
        for key in userDefaults.dictionaryRepresentation().keys {
            userDefaults.removeObject(forKey: key.description)
        }
    }
}

extension UserDefaultsAccessTokenStorage: AccessTokenStorage {
    func fetchToken(for tokenType: TokenType) -> String {
        let token: String
        
        switch tokenType {
        case .access:
            token = userDefaults.string(forKey: accessTokenKey) ?? ""
        case .refresh:
            token = userDefaults.string(forKey: refreshTokenKey) ?? ""
        }
        
        return token
    }
    
    func saveToken(for tokenType: TokenType, with token: String) {
        let tokenKey: String
        
        switch tokenType {
        case .access:
            tokenKey = accessTokenKey
        case .refresh:
            tokenKey = refreshTokenKey
        }
        
        userDefaults.set(token, forKey: tokenKey)
    }
    
    func removeToken() {
        resetUserDefaults()
    }
}
