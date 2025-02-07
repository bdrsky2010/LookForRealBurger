//
//  KeychainService.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 1/5/25.
//

import Foundation

enum KeychainError: Error {
    case error
}

protocol KeychainService {
    func storeData(_ data: Data, completion: @escaping (Result<Void, KeychainError>) -> Void)
    func retrieveData(completion: @escaping (Result<Data, KeychainError>) -> Void)
    func deleteData(completion: @escaping (Result<Void, KeychainError>) -> Void)
}

final class DefaultKeychainService: KeychainService {
    private let account: String
    private let keychainQueue: DispatchQueue
    
    init(account: String = SecureID.account) {
        self.account = account
        self.keychainQueue = DispatchQueue(label: "KEYCHAIN_QUEUE", target: DispatchQueue.global(qos: .background))
    }
    
    func storeData(_ data: Data, completion: @escaping (Result<Void, KeychainError>) -> Void) {
        keychainQueue.sync { [weak self] in
            guard let self else { return }
            
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: account,
                kSecValueData as String: data
            ]
            
            SecItemDelete(query as CFDictionary)
            let status = SecItemAdd(query as CFDictionary, nil)
            
            if status == errSecSuccess {
                completion(.success(()))
            } else {
                completion(.failure(.error))
            }
        }
    }
    
    func retrieveData(completion: @escaping (Result<Data, KeychainError>) -> Void) {
        keychainQueue.sync { [weak self] in
            guard let self else { return }
            
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: account,
                kSecReturnData as String: true
            ]
            
            var item: CFTypeRef?
            let status = SecItemCopyMatching(query as CFDictionary, &item)
            
            if status == errSecSuccess, let data = item as? Data {
                completion(.success(data))
            } else {
                completion(.failure(.error))
            }
        }
    }
    
    func deleteData(completion: @escaping (Result<Void, KeychainError>) -> Void) {
        keychainQueue.sync { [weak self] in
            guard let self else { return }
            
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: account
            ]
            let status = SecItemDelete(query as CFDictionary)
            
            if status == errSecSuccess {
                completion(.success(()))
            } else {
                completion(.failure(.error))
            }
        }
    }
}
