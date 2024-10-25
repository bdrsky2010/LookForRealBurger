//
//  WriteReviewUnitTest.swift
//  LookForRealBurgerTests
//
//  Created by Minjae Kim on 10/25/24.
//

import XCTest
import RxSwift
@testable import LookForRealBurger

final class WriteReviewUnitTest: XCTestCase {
    var sut: WriteReviewViewModel!
    
    let mockUploadPostUseCase = MockUploadPostUseCase()
    
    override func setUpWithError() throws {
        sut = DefaultWriteReviewViewModel(
            uploadPostUseCase: mockUploadPostUseCase,
            accessStorage: MockAccessStorage()
        )
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testPlusRating() {
        let disposeBag = DisposeBag()
        var _rating = 0
        
        for _ in 0..<4 {
            sut.minusRatingTap()
        }
        
        for _ in 0..<2 {
            sut.plusRatingTap()
        }
        
        sut.burgerHouseRating
            .bind { rating in
                print(rating)
                _rating = rating
            }
            .disposed(by: disposeBag)
        
        XCTAssertEqual(_rating, 3, "별점 추가 테스트 실패")
    }
    
    func testPlusMaxRating() {
        let disposeBag = DisposeBag()
        var _rating = 0
        
        for _ in 0..<10 {
            sut.plusRatingTap()
        }
        
        sut.burgerHouseRating
            .bind { rating in
                _rating = rating
            }
            .disposed(by: disposeBag)
        
        XCTAssertEqual(_rating, 5, "별점 추가(Max) 테스트 실패")
    }
    
    func testMinusRating() {
        let disposeBag = DisposeBag()
        var _rating = 0
        
        for _ in 0..<3 {
            sut.minusRatingTap()
        }
        
        sut.burgerHouseRating
            .bind { rating in
                _rating = rating
            }
            .disposed(by: disposeBag)
        
        XCTAssertEqual(_rating, 2, "별점 삭제 테스트 실패")
    }
    
    func testMinusMinRating() {
        let disposeBag = DisposeBag()
        var _rating = 0
        
        for _ in 0..<10 {
            sut.minusRatingTap()
        }
        
        sut.burgerHouseRating
            .bind { rating in
                _rating = rating
            }
            .disposed(by: disposeBag)
        
        XCTAssertEqual(_rating, 1, "별점 삭제(Min) 테스트 실패")
    }
    
    func testUploadImageNoDataFailure() {
        let disposeBag = DisposeBag()
        var failure = false
        
        // given
        let datas = [Data]()
        
        // when
        sut.toastMessage
            .bind { phrase in
                if phrase == R.Phrase.plzImageUpload {
                    failure = true
                }
            }
            .disposed(by: disposeBag)
        
        sut.uploadImage(files: datas)
        
        // then
        XCTAssertTrue(failure, "이미지 업로드 데이터X 테스트 실패")
    }
    
    func testUploadImageOverLimitQuantityFailure() {
        let disposeBag = DisposeBag()
        var failure = false
        
        // given
        let data = UIImage(named: "cartoon_burger")?.jpegData(compressionQuality: 1)
        let datas = Array(repeating: data, count: 6).compactMap { $0 }
        
        // when
        sut.toastMessage
            .bind { phrase in
                if phrase == R.Phrase.limitImageSize {
                    failure = true
                }
            }
            .disposed(by: disposeBag)
        
        sut.uploadImage(files: datas)
        
        // then
        XCTAssertTrue(failure, "이미지 업로드 제한 개수 오버 테스트 실패")
    }
    
    func testUploadPostSuccess() {
        let disposeBag = DisposeBag()
        var success = false
        
        mockUploadPostUseCase.setSuccessUpload(true)
        
        sut.didSuccessUploadReview
            .bind { _ in
                success = true
            }
            .disposed(by: disposeBag)
        
        sut.burgerHouseSelect(burgerHouse: BurgerHouse.dummy)
        sut.uploadPost(title: "", content: "", files: UploadedImage(paths: []))
        
        XCTAssertTrue(success, "리뷰 게시물 업로드(성공) 테스트 실패")
    }
    
    func testUploadPostFailure() {
        let disposeBag = DisposeBag()
        var failure = false
        
        mockUploadPostUseCase.setSuccessUpload(false)
        
        sut.toastMessage
            .bind { _ in
                failure = true
            }
            .disposed(by: disposeBag)
        
        sut.uploadPost(title: "", content: "", files: UploadedImage(paths: []))
        
        XCTAssertTrue(failure, "리뷰 게시물 업로드(실패) 테스트 실패")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
