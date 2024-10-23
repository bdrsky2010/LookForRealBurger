//
//  LoginTest.swift
//  LookForRealBurgerTests
//
//  Created by Minjae Kim on 10/22/24.
//

import XCTest
import RxSwift
@testable import LookForRealBurger

final class LoginUnitTest: XCTestCase {
    var sut: LoginViewModel!
    
    override func setUpWithError() throws {
        sut = DefaultLoginViewModel(loginUseCase: MockLoginUseCase(), accessStorage: MockAccessStorage())
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testLoginSuccess() {
        var success = false
        let disposeBag = DisposeBag()
        // given
        let query = LoginQuery(email: "pass", password: "")
        
        // when
        sut.goToMain
            .bind { _ in
                success = true
            }
            .disposed(by: disposeBag)
        
        sut.didLoginTap(query: query)
        
        // then
        XCTAssertTrue(success, "로그인 성공 테스트 실패")
    }
    
    func testLoginFailure() {
        var failure = false
        let disposeBag = DisposeBag()
        
        // given
        let query = LoginQuery(email: "error", password: "")
        
        // when
        sut.toastMessage
            .bind { _ in
                failure = true
            }
            .disposed(by: disposeBag)
        
        sut.didLoginTap(query: query)
        
        // then
        XCTAssertTrue(failure, "로그인 실패 테스트 실패")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
