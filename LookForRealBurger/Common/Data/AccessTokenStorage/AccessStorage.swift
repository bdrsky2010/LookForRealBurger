//
//  AccessTokenStorage.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/15/24.
//

import Foundation

protocol AccessStorage: AnyObject {
    var accessToken: String { get set }
    var refreshToken: String { get set }
    var loginUserId: String { get set }
    var accessEmail: String { get set }
    var accessPassword: String { get set }
    
    func removeToken()
}

final class UserDefaultsAccessStorage {
    static let shared = UserDefaultsAccessStorage()
    
    private let accessTokenKey = "LookForRealBurgerAccess"
    private let refreshTokenKey = "LookForRealBurgerRefresh"
    private let loginUserIdKey = "LookForRealBurgerLoginUserId"
    private let accessEmailKey = "LookForRealBurgerEmail"
    private let accessPasswordKey = "LookForRealBurgerPassword"
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

extension UserDefaultsAccessStorage: AccessStorage {
    var accessToken: String {
        get { userDefaults.string(forKey: accessTokenKey) ?? "" }
        set { userDefaults.set(newValue, forKey: accessTokenKey) }
    }
    var refreshToken: String {
        get { userDefaults.string(forKey: refreshTokenKey) ?? "" }
        set { userDefaults.set(newValue, forKey: refreshTokenKey) }
    }
    var loginUserId: String {
        get { userDefaults.string(forKey: loginUserIdKey) ?? "" }
        set { userDefaults.set(newValue, forKey: loginUserIdKey) }
    }
    var accessEmail: String {
        get { userDefaults.string(forKey: accessEmailKey) ?? "" }
        set { userDefaults.set(newValue, forKey: accessEmailKey) }
    }
    var accessPassword: String {
        get { userDefaults.string(forKey: accessPasswordKey) ?? "" }
        set { userDefaults.set(newValue, forKey: accessPasswordKey) }
    }
    
    func removeToken() {
        resetUserDefaults()
    }
}
