//
//  BurgerReviewDetailUnitTest.swift
//  LookForRealBurgerTests
//
//  Created by Minjae Kim on 10/23/24.
//

import XCTest
import RxSwift
@testable import LookForRealBurger

final class BurgerReviewDetailUnitTest: XCTestCase {
    var sut: BurgerHouseReviewDetailViewModel!
    let mockBurgerHouseReviewDetailUseCase = MockBurgerHouseReviewDetailUseCase()
    
    override func setUpWithError() throws {
        sut = DefaultBurgerHouseReviewDetailViewModel(
            burgerHouseReviewDetailUseCase: mockBurgerHouseReviewDetailUseCase,
            accessStorage: MockAccessStorage(),
            burgerHouseReview: BurgerHouseReview.dummy
        )
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testGetBurgerHouseSuccess() {
        let disposeBag = DisposeBag()
        var success = false
        
        // given
        mockBurgerHouseReviewDetailUseCase.setSuccessFetch(true)
        
        // when
        sut.configureBurgerHouseButton
            .bind { _ in
                success = true
            }
            .disposed(by: disposeBag)
        
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(success, "햄버거 식당 Fetch(성공) 테스트 실패")
    }
    
    func testGetBurgerHouseFailure() {
        let disposeBag = DisposeBag()
        var failure = false
        
        // given
        mockBurgerHouseReviewDetailUseCase.setSuccessFetch(false)
        
        // when
        sut.toastMessage
            .bind { _ in
                failure = true
            }
            .disposed(by: disposeBag)
        
        sut.viewDidLoad()
        
        // then
        XCTAssertTrue(failure, "햄버거 식당 Fetch(실패) 테스트 실패")
    }
    
    func testLikeTapSuccess() {
        let disposeBag = DisposeBag()
        var success = false
        
        // given
        mockBurgerHouseReviewDetailUseCase.setSuccessFetch(true)
        
        // when
        sut.viewDidLoad()
        
        sut.likeTap()
        
        sut.isLike
            .bind { flag in
                if !flag {
                    success = true
                }
            }
            .disposed(by: disposeBag)
        
        // then
        XCTAssertTrue(success, "좋아요(성공) 테스트 실패")
    }
    
    func testLikeTapFailure() {
        let disposeBag = DisposeBag()
        var failure = false
        
        // given
        mockBurgerHouseReviewDetailUseCase.setSuccessFetch(false)
        
        // when
        sut.viewDidLoad()
        
        sut.likeTap()
        
        sut.isLike
            .bind { flag in
                if flag {
                    failure = true
                }
            }
            .disposed(by: disposeBag)
        
        // then
        XCTAssertTrue(failure, "좋아요(실패) 테스트 실패")
    }
    
    func testBookmarkTapSuccess() {
        let disposeBag = DisposeBag()
        var success = false
        
        // given
        mockBurgerHouseReviewDetailUseCase.setSuccessFetch(true)
        
        // when
        sut.viewDidLoad()
        
        sut.bookmarkTap()
        
        sut.isBookmark
            .bind { flag in
                if !flag {
                    success = true
                }
            }
            .disposed(by: disposeBag)
        
        // then
        XCTAssertTrue(success, "북마크(성공) 테스트 실패")
    }
    
    func testBookmarkTapFailure() {
        let disposeBag = DisposeBag()
        var failure = false
        
        // given
        mockBurgerHouseReviewDetailUseCase.setSuccessFetch(false)
        
        // when
        sut.viewDidLoad()
        
        sut.bookmarkTap()
        
        sut.isBookmark
            .bind { flag in
                if flag {
                    failure = true
                }
            }
            .disposed(by: disposeBag)
        
        // then
        XCTAssertTrue(failure, "북마크(실패) 테스트 실패")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
