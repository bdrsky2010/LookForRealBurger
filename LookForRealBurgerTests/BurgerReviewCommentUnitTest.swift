//
//  BurgerReviewCommentUnitTest.swift
//  LookForRealBurgerTests
//
//  Created by Minjae Kim on 10/23/24.
//

import XCTest
import RxSwift
@testable import LookForRealBurger

final class BurgerReviewCommentUnitTest: XCTestCase {
    var sut: BurgerHouseReviewCommentViewModel!
    
    let mockBurgerHouseReviewCommentUseCase = MockBurgerHouseReviewCommentUseCase()
    
    override func setUpWithError() throws {
        sut = DefaultBurgerHouseReviewCommentlViewModel(
            burgerHouseReviewCommentUseCase: mockBurgerHouseReviewCommentUseCase,
            accessStorage: MockAccessStorage(),
            postId: "",
            comments: [Comment(id: UUID().uuidString, content: "", createdAt: "", creator: Creator(userId: "other", nick: ""))]
        )
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testWriteCommentSuccess() {
        let disposeBag = DisposeBag()
        var success = false
        
        // given
        mockBurgerHouseReviewCommentUseCase.setSuccessFetch(true)
        let text = "안녕하세요"
        
        // when
        sut.configureComments
            .bind { comments in
                guard !comments.isEmpty else { return }
                
                let comment = comments[0]
                if comment.creator.userId == "me",
                   comment.content == text {
                   success = true
                }
            }
            .disposed(by: disposeBag)
        
        sut.sendButtonTap(text: text)
        
        // then
        XCTAssertTrue(success, "리뷰 작성(성공) 테스트 실패")
    }
    
    func testWriteCommentFailure() {
        let disposeBag = DisposeBag()
        var failure = false
        
        // given
        mockBurgerHouseReviewCommentUseCase.setSuccessFetch(false)
        let text = "안녕하세요"
        
        // when
        sut.toastMessage
            .bind { _ in
                failure = true
            }
            .disposed(by: disposeBag)
        
        sut.sendButtonTap(text: text)
        
        // then
        XCTAssertTrue(failure, "리뷰 작성(실패) 테스트 실패")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
