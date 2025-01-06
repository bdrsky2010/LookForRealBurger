//
//  SecureTokenManagerTests.swift
//  LookForRealBurgerTests
//
//  Created by Minjae Kim on 1/5/25.
//

import XCTest

@testable import LookForRealBurger

final class SecureTokenManagerTests: XCTestCase {
    private var sut: SecureTokenManager!
    private var mockSecureEnclaveService: MockSecureEnclaveService!

    override func setUpWithError() throws {
        mockSecureEnclaveService = MockSecureEnclaveService()
        
        sut = TestSecureTokenManager(
            secureEnclaveService: mockSecureEnclaveService,
            keychainService: DefaultKeychainService(account: SecureID.testAccount)
        )
    }

    override func tearDownWithError() throws {
        mockSecureEnclaveService = nil
        sut = nil
    }

    func testEncryptAndStoreTokenSuccess() {
        let expectation = XCTestExpectation(description: "✅ 토큰 암호화 및 저장 키체인 저장 성공 테스트 성공")
        var value = true
        
        mockSecureEnclaveService.encryptSucceed = true
        
        sut.encryptAndStoreToken(token: "TEST_TOKEN") { result in
            switch result {
            case .success:
                value = true
            case .failure:
                value = false
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertTrue(value, "❌ 토큰 암호화 및 저장 키체인 저장 성공 테스트 실패")
    }
    
    func testEncryptAndStoreTokenFailure() {
        let expectation = XCTestExpectation(description: "✅ 토큰 암호화 및 저장 키체인 저장 실패 테스트 성공")
        var value = true
        
        mockSecureEnclaveService.encryptSucceed = false
        
        sut.encryptAndStoreToken(token: "TEST_TOKEN") { result in
            switch result {
            case .success:
                value = true
            case .failure:
                value = false
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertFalse(value, "❌ 토큰 암호화 및 저장 키체인 저장 실패 테스트 실패")
    }
    
    func testRetrieveAndDecryptTokenSuccess() {
        let expectation = XCTestExpectation(description: "✅ 키체인 읽기 및 토큰 복호화 성공 테스트 성공")
        var value: String?
        
        mockSecureEnclaveService.decryptSucceed = true
        
        sut.retrieveAndDecryptToken { result in
            switch result {
            case .success(let token):
                value = token
            case .failure:
                value = nil
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertNotNil(value, "❌ 키체인 읽기 및 토큰 복호화 성공 테스트 실패")
    }
    
    func testRetrieveAndDecryptTokenFailure() {
        let expectation = XCTestExpectation(description: "✅ 키체인 읽기 및 토큰 복호화 실패 테스트 성공")
        var value: String?
        
        mockSecureEnclaveService.decryptSucceed = false
        
        sut.retrieveAndDecryptToken { result in
            switch result {
            case .success(let token):
                value = token
            case .failure:
                value = nil
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertNil(value, "❌ 키체인 읽기 및 토큰 복호화 실패 테스트 실패")
    }
    
    func testDeleteToken() {
        let expectation = XCTestExpectation(description: "✅ 키체인 데이터 삭제 테스트 성공")
        var value = true
        
        sut.deleteToken { result in
            switch result {
            case .success:
                value = true
            case .failure:
                value = false
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertTrue(value, "❌ 키체인 데이터 삭제 테스트 실패")
    }
}
