//
//  OtherProfileUnitTest.swift
//  LookForRealBurgerTests
//
//  Created by Minjae Kim on 10/27/24.
//

import XCTest
import RxSwift
@testable import LookForRealBurger

final class OtherProfileUnitTest: XCTestCase {
    var sut: ProfileViewModel!
    let mockProfileUseCase = MockProfileUseCase()
    
    override func setUpWithError() throws {
        sut = DefaultProfileViewModel(
            ProfileUseCase: mockProfileUseCase,
            accessStorage: MockAccessStorage(),
            profileType: .other("other", "me")
        )
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testFetchOtherProfileSuccess() {
        let disposeBag = DisposeBag()
        var success = false
        
        mockProfileUseCase.setSuccess(true)
        
        sut.setProfile
            .bind { profile in
                if profile.userId == "other" {
                    success = true
                }
            }
            .disposed(by: disposeBag)
        
        sut.viewDidLoad()
        
        XCTAssertTrue(success, "프로필(Other) Fetch(성공) 테스트 실패")
    }
    
    func testFetchOtherProfileFailure() {
        let disposeBag = DisposeBag()
        var failure = false
        
        mockProfileUseCase.setSuccess(false)
        
        sut.toastMessage
            .bind { _ in
                failure = true
            }
            .disposed(by: disposeBag)
        
        sut.viewDidLoad()
        
        XCTAssertTrue(failure, "프로필(Other) Fetch(실패) 테스트 실패")
    }
    
    func testOtherUserFollow() {
        let disposeBag = DisposeBag()
        var success = false
        
        mockProfileUseCase.setSuccess(true)
        mockProfileUseCase.setFollow(false)
        
        sut.setButtonTitle
            .bind { title in
                if title == R.Phrase.followCancel {
                    success = true
                } else {
                    success = false
                }
            }
            .disposed(by: disposeBag)
        
        sut.viewDidLoad()                  // 프로필 패치
        
        mockProfileUseCase.setFollow(true) // 팔로우 요청 설정
        
        sut.followOrEditButtonTap()        // 팔로우 요청 실행
        
        XCTAssertTrue(success, "다른 유저 팔로우 테스트 실패")
    }
    
    func testOtherUserFollowCancel() {
        let disposeBag = DisposeBag()
        var success = false
        
        mockProfileUseCase.setSuccess(true)
        mockProfileUseCase.setFollow(false)
        
        sut.setButtonTitle
            .bind { title in
                if title == R.Phrase.followRequest {
                    success = true
                } else {
                    success = false
                }
            }
            .disposed(by: disposeBag)
        
        sut.viewDidLoad()                   // 프로필 패치
        
        mockProfileUseCase.setFollow(true)  // 팔로우 요청 설정
        
        sut.followOrEditButtonTap()         // 팔로우 요청 실행
        
        mockProfileUseCase.setFollow(false) // 팔로우 취소 설정
        
        sut.followOrEditButtonTap()         // 팔로우 취소 실행
        
        XCTAssertTrue(success, "다른 유저 팔로우 취소 테스트 실패")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
