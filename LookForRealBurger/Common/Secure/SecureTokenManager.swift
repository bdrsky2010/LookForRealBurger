//
//  SecureTokenManager.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 1/5/25.
//

import Foundation

enum SecureError: Error {
    case error
}

protocol SecureTokenManager {
    func encryptAndStoreToken(token: String, completion: @escaping (Result<Void, SecureError>) -> Void)
    func retrieveAndDecryptToken(completion: @escaping (Result<String, SecureError>) -> Void)
    func deleteToken(completion: @escaping (Result<Void, SecureError>) -> Void)
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
    
    func encryptAndStoreToken(token: String, completion: @escaping (Result<Void, SecureError>) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            guard let tokenData = token.data(using: .utf8),
                  let encryptedData = secureEnclaveService.encryptData(data: tokenData) else {
                print("❌ 토큰 암호화 실패")
                completion(.failure(.error))
                return
            }
            
            keychainService.storeData(encryptedData) { result in
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let failure):
                    completion(.failure(.error))
                }
            }
        }
    }
    
    func retrieveAndDecryptToken(completion: @escaping (Result<String, SecureError>) -> Void) {
        keychainService.retrieveData { result in
            switch result {
            case .success(let encryptedData):
                DispatchQueue.global().async { [weak self] in
                    guard let self else { return }
                    if let decryptedData = secureEnclaveService.decryptData(data: encryptedData),
                       let token = String(data: decryptedData, encoding: .utf8) {
                        print("✅ 복호화된 토큰: \(token)")
                        completion(.success(token))
                    } else {
                        print("❌ 토큰 복호화 실패")
                        completion(.failure(.error))
                    }
                }
            case .failure(let failure):
                print("❌ 토큰 복호화 실패")
                completion(.failure(.error))
            }
        }
    }
    
    func deleteToken(completion: @escaping (Result<Void, SecureError>) -> Void) {
        keychainService.deleteData { result in
            switch result {
            case .success:
                print("✅ Keychain 데이터 삭제 완료")
                completion(.success(()))
            case .failure:
                print("❌ Keychain 데이터 삭제 실패")
                completion(.failure(.error))
            }
        }
    }
}

final class TestSecureTokenManager: SecureTokenManager {
    private let secureEnclaveService: MockSecureEnclaveService
    private let keychainService: KeychainService
    
    init(
        secureEnclaveService: MockSecureEnclaveService,
        keychainService: KeychainService
    ) {
        self.secureEnclaveService = secureEnclaveService
        self.keychainService = keychainService
    }
    
    func encryptAndStoreToken(token: String, completion: @escaping (Result<Void, SecureError>) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            guard let tokenData = token.data(using: .utf8),
                  let encryptedData = secureEnclaveService.encryptData(data: tokenData) else {
                print("❌ 토큰 암호화 실패")
                completion(.failure(.error))
                return
            }
            
            keychainService.storeData(encryptedData) { result in
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let failure):
                    completion(.failure(.error))
                }
            }
        }
    }
    
    func retrieveAndDecryptToken(completion: @escaping (Result<String, SecureError>) -> Void) {
        keychainService.retrieveData { result in
            switch result {
            case .success(let encryptedData):
                DispatchQueue.global().async { [weak self] in
                    guard let self else { return }
                    if let decryptedData = secureEnclaveService.decryptData(data: encryptedData),
                       let token = String(data: decryptedData, encoding: .utf8) {
                        print("✅ 복호화된 토큰: \(token)")
                        completion(.success(token))
                    } else {
                        print("❌ 토큰 복호화 실패")
                        completion(.failure(.error))
                    }
                }
            case .failure(let failure):
                print("❌ 토큰 복호화 실패")
                completion(.failure(.error))
            }
        }
    }
    
    func deleteToken(completion: @escaping (Result<Void, SecureError>) -> Void) {
        keychainService.deleteData { result in
            switch result {
            case .success:
                print("✅ Keychain 데이터 삭제 완료")
                completion(.success(()))
            case .failure:
                print("❌ Keychain 데이터 삭제 실패")
                completion(.failure(.error))
            }
        }
    }
}
