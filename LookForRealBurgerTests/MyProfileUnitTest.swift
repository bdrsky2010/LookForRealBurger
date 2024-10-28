//
//  MyProfileUnitTest.swift
//  LookForRealBurgerTests
//
//  Created by Minjae Kim on 10/27/24.
//

import XCTest
import RxSwift
@testable import LookForRealBurger

final class MyProfileUnitTest: XCTestCase {
    var sut: ProfileViewModel!
    let mockProfileUseCase = MockProfileUseCase()
    
    override func setUpWithError() throws {
        sut = DefaultProfileViewModel(
            ProfileUseCase: mockProfileUseCase,
            accessStorage: MockAccessStorage(),
            profileType: .me("me")
        )
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testFetchMyProfileSuccess() {
        let disposeBag = DisposeBag()
        var success = false
        
        mockProfileUseCase.setSuccess(true)
        
        sut.setProfile
            .bind { profile in
                if profile.userId == "me" {
                    success = true
                }
            }
            .disposed(by: disposeBag)
        
        sut.viewDidLoad()
        
        XCTAssertTrue(success, "프로필(My) Fetch(성공) 테스트 실패")
    }
    
    func testFetchMyProfileFailure() {
        let disposeBag = DisposeBag()
        var failure = false
        
        mockProfileUseCase.setSuccess(false)
        
        sut.toastMessage
            .bind { _ in
                failure = true
            }
            .disposed(by: disposeBag)
        
        sut.viewDidLoad()
        
        XCTAssertTrue(failure, "프로필(My) Fetch(실패) 테스트 실패")
    }
    
    func testRefreshProfile() {
        let disposeBag = DisposeBag()
        var success = false
        
        mockProfileUseCase.setSuccess(true)
        
        sut.endRefreshing
            .bind { _ in
                success = true
            }
            .disposed(by: disposeBag)
        
        sut.profileRefresh()
        
        XCTAssertTrue(success, "프로필 Refresh 테스트 실패")
    }
    
    func testFollowLabelTap() {
        let disposeBag = DisposeBag()
        var success = false
        
        mockProfileUseCase.setSuccess(true)
        
        sut.viewDidLoad()
        
        sut.pushFollowView
            .bind { follows in
                if follows.followers.contains(where: { $0.userId == "other" }),
                   follows.followers.contains(where: { $0.userId == "another" }) {
                    success = true
                }
            }
            .disposed(by: disposeBag)
        
        sut.followLabelTap(followType: .follow)
        
        XCTAssertTrue(success, "팔로우 유저 데이터 전달 테스트 실패")
    }
    
    func testFollowingLabelTap() {
        let disposeBag = DisposeBag()
        var success = false
        
        mockProfileUseCase.setSuccess(true)
        
        sut.viewDidLoad()
        
        sut.pushFollowView
            .bind { follows in
                if follows.followings.contains(where: { $0.userId == "other" }) {
                    success = true
                }
            }
            .disposed(by: disposeBag)
        
        sut.followLabelTap(followType: .following)
        
        XCTAssertTrue(success, "팔로우 유저 데이터 전달 테스트 실패")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
