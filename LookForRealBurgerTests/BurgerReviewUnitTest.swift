//
//  BurgerReviewUnitTest.swift
//  LookForRealBurgerTests
//
//  Created by Minjae Kim on 10/23/24.
//

import XCTest
import RxSwift
@testable import LookForRealBurger

final class BurgerReviewUnitTest: XCTestCase {
    var sut: BurgerHouseReviewViewModel!
    
    let mockBurgerHouseReviewUseCase = MockBurgerHouseReviewUseCase()
    
    override func setUpWithError() throws {
        sut = DefaultBurgerHouseReviewViewModel(
            burgerReviewUseCase: mockBurgerHouseReviewUseCase,
            accessStorage: MockAccessStorage(),
            getPostType: .total
        )
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testFirstFetchBurgerHouseReviewSuccess() {
        var success = false
        
        // given
        mockBurgerHouseReviewUseCase.setSuccessFetch(true)
        
        // when
        sut.firstFetchBurgerHouseReview()
        
        if let cursor = sut.nextCursor, cursor == "next" {
            success = true
        }
        
        // then
        XCTAssertTrue(success, "첫 리뷰 Fetch(성공) 테스트 실패")
    }
    
    func testFirstFetchBurgerHouseReviewFailure() {
        let disposeBag = DisposeBag()
        var failure = false
        
        // given
        mockBurgerHouseReviewUseCase.setSuccessFetch(false)
        
        // when
        sut.toastMessage
            .bind { _ in
                failure = true
            }
            .disposed(by: disposeBag)
        
        sut.firstFetchBurgerHouseReview()
        
        // then
        XCTAssertTrue(failure, "첫 리뷰 Fetch(실패) 테스트 실패")
    }
    
    func testNextFetchBurgerHouseReviewSuccess() {
        var success = false
        
        // given
        mockBurgerHouseReviewUseCase.setSuccessFetch(true)
        
        // when
        sut.firstFetchBurgerHouseReview()
        
        if let cursor = sut.nextCursor, cursor == "next" {
            sut.nextFetchBurgerHouseReview()
        }
        if let cursor = sut.nextCursor, cursor == "0" {
            success = true
        }
        
        // then
        XCTAssertTrue(success, "리뷰 Next Fetch(성공) 테스트 실패")
    }
    
    func testDoNotMoreFetchBurgerHouseReview() {
        var success = false
        
        // given
        mockBurgerHouseReviewUseCase.setSuccessFetch(true)
        
        // when
        sut.firstFetchBurgerHouseReview()
        
        if let cursor = sut.nextCursor, cursor == "next" {
            sut.nextFetchBurgerHouseReview()
        }
        if let cursor = sut.nextCursor, cursor == "0" {
            sut.nextFetchBurgerHouseReview()
        }
        if let cursor = sut.nextCursor, cursor != "X" {
            success = true
        }
        
        // then
        XCTAssertTrue(success, "리뷰 더 이상 Pagination X(성공) 테스트 실패")
    }
    
    func testRefreshAccessTokenSuccess() {
        var success = false
        
        // given
        mockBurgerHouseReviewUseCase.setSuccessRefresh(true)
        
        // when
        sut.refreshAccessToken {
            success = true
        }
        
        // then
        XCTAssertTrue(success, "액세스 토큰 리프레시(성공) 테스트 실패")
    }
    
    func testRefreshAccessTokenFailure() {
        let disposeBag = DisposeBag()
        var failure = false
        
        // given
        mockBurgerHouseReviewUseCase.setSuccessRefresh(false)
        
        // when
        sut.toastMessage
            .bind { _ in
                failure = true
            }
            .disposed(by: disposeBag)
        
        sut.refreshAccessToken {
            failure = false
        }
        
        // then
        XCTAssertTrue(failure, "액세스 토큰 리프레시(실패) 테스트 실패")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
