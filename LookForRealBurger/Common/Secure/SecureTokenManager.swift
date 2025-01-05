//
//  SecureTokenManager.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 1/5/25.
//

import Foundation

protocol SecureTokenManager {
    func encryptAndStoreToken(mockToken: String) -> Bool
    func retrieveAndDecryptToken() -> String?
    func deleteToken()
}

final class DefaultSecureTokenManager: SecureTokenManager {
    static let shared = DefaultSecureTokenManager(
        secureEnclaveService: DefaultSecureEnclaveService(),
        keychainService: DefaultKeychainService()
    )
    
    private let secureEnclaveService: SecureEnclaveService
    private let keychainService: KeychainService
    
    private init(
        secureEnclaveService: SecureEnclaveService,
        keychainService: KeychainService
    ) {
        self.secureEnclaveService = secureEnclaveService
        self.keychainService = keychainService
    }
    
    func encryptAndStoreToken(mockToken: String) -> Bool {
        guard let tokenData = mockToken.data(using: .utf8),
              let encryptedData = secureEnclaveService.encryptData(data: tokenData) else {
            print("❌ 토큰 암호화 실패")
            return false
        }
        
        return keychainService.storeData(encryptedData)
    }
    
    func retrieveAndDecryptToken() -> String? {
        guard let encryptedData = keychainService.retrieveData(),
              let decryptedData = secureEnclaveService.decryptData(data: encryptedData),
              let token = String(data: decryptedData, encoding: .utf8) else {
            print("❌ 토큰 복호화 실패")
            return nil
        }
        
        print("✅ 복호화된 토큰: \(token)")
        return token
    }
    
    func deleteToken() {
        let isDelete = keychainService.deleteData()
        if isDelete {
            print("✅ Keychain 데이터 삭제 완료")
        } else {
            print("❌ Keychain 데이터 삭제 실패")
        }
    }
}
