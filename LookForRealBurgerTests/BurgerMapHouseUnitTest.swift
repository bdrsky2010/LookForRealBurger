//
//  BurgerMapHouseTest.swift
//  LookForRealBurgerTests
//
//  Created by Minjae Kim on 10/23/24.
//

import XCTest
import RxSwift
@testable import LookForRealBurger

final class BurgerMapHouseUnitTest: XCTestCase {
    var sut: BurgerMapHouseViewModel!
    
    let mockBurgerMapHouseUseCase = MockBurgerMapHouseUseCase()
    
    override func setUpWithError() throws {
        sut = DefaultBurgerMapHouseViewModel(
            burgerMapHouseUseCase: mockBurgerMapHouseUseCase,
            accessStorage: MockAccessStorage(),
            burgerMapHouse: BurgerMapHouse.dummy
        )
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testfetchSingleReviewSuccess() {
        var success = false
        
        // given
        let postId = "id"
        
        // when
        sut.fetchSingleReview(postId: postId) { _ in
            success = true
        }
        
        // then
        XCTAssertTrue(success, "단일 리뷰 패치(성공) 테스트 실패")
    }
    
    func testfetchSingleReviewFailure() {
        let disposeBag = DisposeBag()
        var failure = false
        
        // given
        let postId = ""
        
        // when
        sut.toastMessage
            .bind { _ in
                failure = true
            }
            .disposed(by: disposeBag)
        
        sut.fetchSingleReview(postId: postId) { _ in
            failure = false
        }
        
        // then
        XCTAssertTrue(failure, "단일 리뷰 패치(실패) 테스트 실패")
    }
    
    func testRefreshAccessTokenSuccess() {
        var success = false
        
        // given
        mockBurgerMapHouseUseCase.setSuccessRefresh(true)
        
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
        mockBurgerMapHouseUseCase.setSuccessRefresh(false)
        
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
