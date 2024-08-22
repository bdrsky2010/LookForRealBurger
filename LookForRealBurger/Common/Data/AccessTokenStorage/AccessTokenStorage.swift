//
//  AccessTokenStorage.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/15/24.
//

import Foundation

protocol AccessTokenStorage: AnyObject {
    var accessToken: String { get set }
    var refreshToken: String { get set }
    
    func removeToken()
}

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
    var accessToken: String {
        get {
            userDefaults.string(forKey: accessTokenKey) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: accessTokenKey)
        }
    }
    
    var refreshToken: String {
        get {
            userDefaults.string(forKey: refreshTokenKey) ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: refreshTokenKey)
        }
    }
    
    func removeToken() {
        resetUserDefaults()
    }
}
