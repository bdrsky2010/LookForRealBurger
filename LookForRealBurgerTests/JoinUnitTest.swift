//
//  JoinTest.swift
//  LookForRealBurgerTests
//
//  Created by Minjae Kim on 10/23/24.
//

import XCTest
import RxSwift
@testable import LookForRealBurger

final class JoinUnitTest: XCTestCase {
    var sut: JoinViewModel!
    
    override func setUpWithError() throws {
        sut = DefaultLFRBJoinViewModel(joinUseCase: MockJoinUsecase())
    }

    func testEmailValidationSuccess() {
        let disposeBag = DisposeBag()
        var success = false
        
        // given
        let text = "timmy@timmy.com"
        
        // when
        sut.isValidEmail
            .bind(with: self) { owner, isValid in
                if isValid { success = true }
            }
            .disposed(by: disposeBag)
        
        sut.didEditEmailText(text: text)
        
        // then
        XCTAssertTrue(success, "이메일 유효성 검사 성공테스트 실패")
    }
    
    func testEmailValidationFailure() {
        let disposeBag = DisposeBag()
        var failure = false
        
        // given
        let text = "timmy"
        
        // when
        sut.isValidEmail
            .bind(with: self) { owner, isValid in
                if !isValid { failure = true }
            }
            .disposed(by: disposeBag)
        
        sut.didEditEmailText(text: text)
        
        // then
        XCTAssertTrue(failure, "이메일 유효성 검사 실패테스트 실패")
    }
    
    func testEmailIsNotDuplicate() {
        let disposeBag = DisposeBag()
        var isNotDuplicate = false
        
        // given
        let email = "notDuplicate"
        
        // when
        sut.isNotDuplicateEmail
            .bind { state in
                if state { isNotDuplicate = true }
            }
            .disposed(by: disposeBag)
        
        sut.didTapEmailValid(email: email)
        
        // then
        XCTAssertTrue(isNotDuplicate, "이메일 중복검사(중복X) 테스트 실패")
    }
    
    func testEmailIsDuplicate() {
        let disposeBag = DisposeBag()
        var isDuplicate = false
        
        // given
        let email = "duplicate"
        
        // when
        sut.isNotDuplicateEmail
            .bind { state in
                if !state { isDuplicate = true }
            }
            .disposed(by: disposeBag)
        
        sut.didTapEmailValid(email: email)
        
        // then
        XCTAssertTrue(isDuplicate, "이메일 중복검사(중복O) 테스트 실패")
    }
    
    func testJoinSuccess() {
        let disposeBag = DisposeBag()
        var success = false
        
        // given
        let query = JoinQuery(email: "pass", password: "", nick: "")
        
        // when
        sut.isSuccessJoin
            .bind { _ in
                success = true
            }
            .disposed(by: disposeBag)
        
        sut.didTapJoin(query: query)
        
        // then
        XCTAssertTrue(success, "회원가입(성공) 테스트 실패")
    }
    
    func testJoinFailure() {
        let disposeBag = DisposeBag()
        var failure = false
        
        // given
        let query = JoinQuery(email: "error", password: "", nick: "")
        
        // when
        sut.toastMessage
            .bind { _ in
                failure = true
            }
            .disposed(by: disposeBag)
        
        sut.didTapJoin(query: query)
        
        // then
        XCTAssertTrue(failure, "회원가입(실패) 테스트 실패")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
