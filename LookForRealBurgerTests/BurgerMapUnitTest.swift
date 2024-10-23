//
//  BurgerMapTest.swift
//  LookForRealBurgerTests
//
//  Created by Minjae Kim on 10/23/24.
//

import XCTest
import RxSwift
@testable import LookForRealBurger

final class BurgerMapUnitTest: XCTestCase {
    var sut: BurgerMapViewModel!
    
    let mockLocationManager = MockLocationManager()
    let mockBurgerMapUseCase = MockBurgerMapUseCase()
    
    override func setUpWithError() throws {
        sut = DefaultBurgerMapViewModel(
            locationManager: mockLocationManager,
            burgerMapUseCase: mockBurgerMapUseCase,
            accessStorage: MockAccessStorage()
        )
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testRequestAuthAlert() {
        let disposeBag = DisposeBag()
        var success = false
        
        // given
        mockLocationManager.setAuthrized(true)
        
        // when
        sut.requestAuthAlert
            .bind { _ in
                success = true
            }
            .disposed(by: disposeBag)
        
        sut.updateLocation()
        
        // then
        XCTAssertTrue(success, "권한 요청 알림 받기 테스트 실패")
    }
    
    func testGetUserCoordinate() {
        let disposeBag = DisposeBag()
        var success = false
        
        // given
        mockLocationManager.setAuthrized(false)
        
        // when
        sut.setRegion
            .bind { coordinate in
                if coordinate.latitude == 1, coordinate.longitude == 1 {
                    success = true
                }
            }
            .disposed(by: disposeBag)
        
        sut.updateLocation()
        
        // then
        XCTAssertTrue(success, "유저 위치 정보 받아오기 테스트 실패")
    }
    
    func testFetchBurgerMapHouseSuccess() {
        let disposeBag = DisposeBag()
        var success = false
        
        // given
        mockBurgerMapUseCase.setSuccessFetch(true)
        
        // when
        sut.burgerMapHouses
            .bind { _ in
                success = true
            }
            .disposed(by: disposeBag)
        
        sut.fetchBurgerMapHouse()
        
        // then
        XCTAssertTrue(success, "버거 식당 fetch(성공) 테스트 실패")
    }
    
    func testFetchBurgerMapHouseFailure() {
        let disposeBag = DisposeBag()
        var failure = false
        
        // given
        mockBurgerMapUseCase.setSuccessFetch(false)
        
        // when
        sut.toastMessage
            .bind { _ in
                failure = true
            }
            .disposed(by: disposeBag)
        
        sut.fetchBurgerMapHouse()
        
        // then
        XCTAssertTrue(failure, "버거 식당 fetch(실패) 테스트 실패")
    }
    
    func testRefreshAccessTokenSuccess() {
        var success = false
        
        // given
        mockBurgerMapUseCase.setSuccessRefresh(true)
        
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
        mockBurgerMapUseCase.setSuccessRefresh(false)
        
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
