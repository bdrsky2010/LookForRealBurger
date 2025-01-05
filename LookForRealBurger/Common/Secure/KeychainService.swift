//
//  KeychainService.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 1/5/25.
//

import Foundation

protocol KeychainService {
    func storeData(_ data: Data) -> Bool
    func retrieveData() -> Data?
    func deleteData() -> Bool
}

final class DefaultKeychainService: KeychainService {
    private let account = SecureID.account
    
    func storeData(_ data: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    func retrieveData() -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess else { return nil }
        
        return item as? Data
    }
    
    func deleteData() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account
        ]
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess { return true }
        else { return false }
    }
}
