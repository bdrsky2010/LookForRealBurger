//
//  SearchBurgerHouseUnitTest.swift
//  LookForRealBurgerTests
//
//  Created by Minjae Kim on 10/25/24.
//

import XCTest
import RxSwift
@testable import LookForRealBurger

final class SearchBurgerHouseUnitTest: XCTestCase {
    var sut: SearchBurgerHouseViewModel!
    
    let mockLocalSearchUseCase = MockLocalSearchUseCase()
    
    override func setUpWithError() throws {
        sut = DefaultSearchBurgerHouseViewModel(
            localSearchUseCase: mockLocalSearchUseCase,
            locationManager: MockLocationManager(),
            accessStorage: MockAccessStorage()
        )
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testSearchTextSuccess() {
        let disposeBag = DisposeBag()
        var success = false
        
        mockLocalSearchUseCase.setSuccessExecute(true)
        
        sut.searchText(type: .search, text: "")
        
        sut.burgerHouses
            .bind { houses in
                if let house = houses.first, house.id == "start" {
                    success = true
                }
            }
            .disposed(by: disposeBag)
        
        XCTAssertTrue(success, "햄버거 식당 검색(성공) 테스트 실패")
    }
    
    func testSearchTextFailure() {
        let disposeBag = DisposeBag()
        var failure = false
        
        mockLocalSearchUseCase.setSuccessExecute(false)
        
        sut.toastMessage
            .bind { _ in
                failure = true
            }
            .disposed(by: disposeBag)
        
        sut.searchText(type: .search, text: "")
        
        XCTAssertTrue(failure, "햄버거 식당 검색(실패) 테스트 실패")
    }
    
    func testSearchTextPaginationSuccess() {
        let disposeBag = DisposeBag()
        var success = false
        
        mockLocalSearchUseCase.setSuccessExecute(true)
        
        sut.searchText(type: .search, text: "")
        sut.searchText(type: .pagination, text: "")
        
        sut.burgerHouses
            .bind { houses in
                if let house = houses.last, house.id == "end" {
                    success = true
                }
            }
            .disposed(by: disposeBag)
        
        XCTAssertTrue(success, "햄버거 식당 검색 페이지네이션 테스트 실패")
    }
    
    func testSearchTextEndPaginationSuccess() {
        let disposeBag = DisposeBag()
        var success = false
        
        mockLocalSearchUseCase.setSuccessExecute(true)
        
        sut.searchText(type: .search, text: "")
        sut.searchText(type: .pagination, text: "")
        sut.searchText(type: .pagination, text: "")
        
        sut.burgerHouses
            .bind { houses in
                if let house = houses.last,
                   house.id == "end",
                   houses.count == 2 {
                    success = true
                }
            }
            .disposed(by: disposeBag)
        
        XCTAssertTrue(success, "햄버거 식당 검색 페이지네이션 끝 테스트 실패")
    }
    
    func testExistBurgerHouseSuccess() {
        let disposeBag = DisposeBag()
        var success = false
        
        mockLocalSearchUseCase.setSuccessExecute(true)
        
        sut.selectItem
            .bind { item in
                if item.burgerHousePostId == "exist" {
                    success = true
                }
            }
            .disposed(by: disposeBag)
        
        sut.modelSelected(item: BurgerHouse(id: "exist", name: "", placeUrl: "", address: "", roadAddress: "", phone: "", x: "", y: ""))
        
        XCTAssertTrue(success, "서버 내 식당 데이터 존재(O)(성공) 테스트 실패")
    }
    
    func testExistBurgerHouseFailure() {
        let disposeBag = DisposeBag()
        var failure = false
        
        mockLocalSearchUseCase.setSuccessExecute(false)
        
        sut.toastMessage
            .bind { _ in
                failure = true
            }
            .disposed(by: disposeBag)
        
        sut.modelSelected(item: BurgerHouse(id: "exist", name: "", placeUrl: "", address: "", roadAddress: "", phone: "", x: "", y: ""))
        
        XCTAssertTrue(failure, "서버 내 식당 데이터 존재(실패) 테스트 실패")
    }
    
    func testNotExistBurgerHouseSuccess() {
        let disposeBag = DisposeBag()
        var success = false
        
        mockLocalSearchUseCase.setSuccessExecute(true)
        
        sut.selectItem
            .bind { item in
                if item.burgerHousePostId == "notExist" {
                    success = true
                }
            }
            .disposed(by: disposeBag)
        
        sut.modelSelected(item: BurgerHouse(id: "notExist", name: "", placeUrl: "", address: "", roadAddress: "", phone: "", x: "", y: ""))
        
        XCTAssertTrue(success, "서버 내 식당 데이터 존재(X) -> 새로 업로드(성공) 테스트 실패")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
