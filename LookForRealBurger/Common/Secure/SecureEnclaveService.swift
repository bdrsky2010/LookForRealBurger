//
//  SecureEnclaveService.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 1/5/25.
//

import Foundation

protocol SecureEnclaveService {
    func getOrCreateSecureEnclaveKey() -> SecKey?
    func encryptData(data: Data) -> Data?
    func decryptData(data: Data) -> Data?
}

final class DefaultSecureEnclaveService: SecureEnclaveService {
    private let account = SecureID.account
    
    /// ✅ Secure Enclave 키 생성 (시뮬레이터 대응 포함)
    func getOrCreateSecureEnclaveKey() -> SecKey? {
        let tag = account.data(using: .utf8)!
        
        #if targetEnvironment(simulator)
        print("🖥️ 시뮬레이터 감지: Secure Enclave 미지원")
        return nil
        #else
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecReturnRef as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecSuccess {
            print("✅ 기존 Secure Enclave 키 사용")
            return (item as! SecKey)
        }
        
        // 키 생성 (실제 기기)
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeySizeInBits as String: 256,
            kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
            kSecPrivateKeyAttrs as String: [
                kSecAttrApplicationTag as String: tag,
                kSecAttrIsPermanent as String: true
            ]
        ]
        
        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            print("❌ Secure Enclave 키 생성 실패: \(error!.takeRetainedValue())")
            return nil
        }
        
        print("🔑 새 Secure Enclave 키 생성 완료")
        return privateKey
        #endif
    }
    
    /// ✅ 데이터 암호화 (시뮬레이터 대응)
    func encryptData(data: Data) -> Data? {
        #if targetEnvironment(simulator)
        print("🖥️ 시뮬레이터: AES 암호화로 대체")
        return data
        #else
        guard let privateKey = getOrCreateSecureEnclaveKey(),
              let publicKey = SecKeyCopyPublicKey(privateKey) else { return nil }
        
        var error: Unmanaged<CFError>?
        guard let encryptedData = SecKeyCreateEncryptedData(
            publicKey,
            .eciesEncryptionStandardX963SHA256AESGCM,
            data as CFData,
            &error
        ) else {
            print("❌ 데이터 암호화 실패: \(error!.takeRetainedValue())")
            return nil
        }
        
        return encryptedData as Data
        #endif
    }
    
    /// ✅ 데이터 복호화 (시뮬레이터 대응)
    func decryptData(data: Data) -> Data? {
        #if targetEnvironment(simulator)
        print("🖥️ 시뮬레이터: 암호화 없이 데이터 반환")
        return data
        #else
        guard let privateKey = getOrCreateSecureEnclaveKey() else { return nil }
        
        var error: Unmanaged<CFError>?
        guard let decryptedData = SecKeyCreateDecryptedData(
            privateKey,
            .eciesEncryptionStandardX963SHA256AESGCM,
            data as CFData,
            &error
        ) else {
            print("❌ 데이터 복호화 실패: \(error!.takeRetainedValue())")
            return nil
        }
        
        return decryptedData as Data
        #endif
    }
}
