//
//  SearchBurgerHouseViewModel.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/25/24.
//

import Foundation

import RxCocoa
import RxSwift

enum RequestType {
    case search
    case pagination
}

protocol SearchBurgerHouseInput {
    func viewWillAppear()
    func viewWillDisAppear()
    func didTapBack()
    func didChangeText(text: String)
    func searchText(type: RequestType, text: String)
    func modelSelected(item: BurgerHouse)
    func notExistBurgerHouse(burgerHouse: BurgerHouse)
}

protocol SearchBurgerHouseOutput {
    var requestAuthAlert: PublishRelay<String> { get }
    var popView: PublishRelay<Void> { get }
    var isSearchEnabled: PublishRelay<Bool> { get }
    var burgerHouses: BehaviorRelay<[BurgerHouse]> { get }
    var toastMessage: PublishRelay<String> { get }
    var selectItem: PublishRelay<BurgerHouse> { get }
    var nextPage: Int { get }
    var isEndPage: Bool { get }
}

typealias SearchBurgerHouseViewModel = SearchBurgerHouseInput & SearchBurgerHouseOutput

final class DefaultSearchBurgerHouseViewModel: SearchBurgerHouseOutput {
    var requestAuthAlert = PublishRelay<String>()
    var popView = PublishRelay<Void>()
    var isSearchEnabled = PublishRelay<Bool>()
    var burgerHouses = BehaviorRelay<[BurgerHouse]>(value: [])
    var toastMessage = PublishRelay<String>()
    var selectItem = PublishRelay<BurgerHouse>()
    
    private(set) var nextPage = 1
    private(set) var isEndPage = false
    
    private let localSearchUseCase: LocalSearchUseCase
    private let locationManager: LocationManager
    private let disposeBag: DisposeBag
    
    init(
        localSearchUseCase: LocalSearchUseCase,
        locationManager: LocationManager,
        disposeBag: DisposeBag = DisposeBag()
    ) {
        self.localSearchUseCase = localSearchUseCase
        self.locationManager = locationManager
        self.disposeBag = disposeBag
    }
}

extension DefaultSearchBurgerHouseViewModel: SearchBurgerHouseInput {
    func viewWillAppear() {
        locationManager.requestAuthAlert
            .bind(to: requestAuthAlert)
            .disposed(by: disposeBag)
        
        locationManager.checkDeviceLocationAuthorization()
    }
    
    func viewWillDisAppear() {
        locationManager.stopUpdatingLocation()
    }
    
    func didTapBack() {
        popView.accept(())
    }
    
    func didChangeText(text: String) {
        isSearchEnabled.accept(!text.isEmpty)
    }
    
    func searchText(type: RequestType, text: String) {
        if type == .search {
            nextPage = 1
            isEndPage = false
        }
        
        guard !isEndPage else { return }
        
        let data = Observable.combineLatest(
            Observable.just(locationManager.coordinate),
            Observable.just(nextPage),
            Observable.just(text)
        )
        
        data
            .map {
                LocalSearchQuery(
                    query: $2,
                    x: $0.value.longitude,
                    y: $0.value.latitude,
                    page: $1
                )
            }
            .subscribe(with: self) { owner, localSearchQuery in
                owner.localSearchUseCase
                    .localSearchExecute(query: localSearchQuery)
                    .asDriver(onErrorJustReturn: .failure(.noData(message: R.Phrase.errorOccurred)))
                    .drive(with: self) { owner, result in
                        switch result {
                        case .success(let value):
                            owner.isEndPage = value.isEndPage
                            owner.nextPage = value.nextPage
                            if owner.nextPage == 2 {
                                owner.burgerHouses.accept(value.burgerHouses)
                            } else {
                                var list = owner.burgerHouses.value
                                list.append(contentsOf: value.burgerHouses)
                                owner.burgerHouses.accept(list)
                            }
                        case .failure(let error):
                            let errorMessage: String
                            switch error {
                            case .invalidURL(let message):
                                errorMessage = message
                            case .noData(let message):
                                errorMessage = message
                            case .badRequest(let message):
                                errorMessage = message
                            case .unauthorized(let message):
                                errorMessage = message
                            case .forbidden(let message):
                                errorMessage = message
                            case .tooManyRequest(let message):
                                errorMessage = message
                            case .internalServerError(let message):
                                errorMessage = message
                            case .badGateway(message: let message):
                                errorMessage = message
                            case .serviceUnavilable(message: let message):
                                errorMessage = message
                            case .unknown(message: let message):
                                errorMessage = message
                            }
                            owner.toastMessage.accept(errorMessage)
                        }
                    } onCompleted: { _ in
                        print("localSearchExecute completed")
                    } onDisposed: { _ in
                        print("localSearchExecute disposed")
                    }
                    .disposed(by: owner.disposeBag)
                
            }
            .disposed(by: disposeBag)
    }
    
    func modelSelected(item: BurgerHouse) {
        let getPostQuery = GetPostQuery(
            next: nil,
            limit: "10000",
            productId: LFRBProductID.burgerHouseTest.rawValue
        )
        localSearchUseCase.existBurgerHouseExecute(query: getPostQuery, localId: item.id)
            .asDriver(onErrorJustReturn: .failure(.unknown(message: R.Phrase.errorOccurred)))
            .drive(with: self) { owner, result in
                switch result {
                case .success(let value):
                    if value.isExist {
                        var result = item
                        result.burgerHousePostId = value.burgerHousePostId
                        owner.selectItem.accept(result)
                    } else {
                        print("식당 데이터 없음 저장해야 함")
                        owner.notExistBurgerHouse(burgerHouse: item)
                    }
                case .failure(let error):
                    switch error {
                    case .network(let message):
                        owner.toastMessage.accept(message)
                    case .badRequest(let message):
                        owner.toastMessage.accept(message)
                    case .invalidToken(let message):
                        owner.toastMessage.accept(message)
                    case .forbidden(let message):
                        owner.toastMessage.accept(message)
                    case .expiredToken:
                        print("existBurgerHouseExecute 액세스 토큰 만료")
                    case .unknown(let message):
                        owner.toastMessage.accept(message)
                    }
                }
            } onCompleted: { _ in
                print("existBurgerHouseExecute completed")
            } onDisposed: { _ in
                print("existBurgerHouseExecute disposed")
            }
            .disposed(by: disposeBag)
    }
    
    func notExistBurgerHouse(burgerHouse: BurgerHouse) {
        let uploadBurgerHouseQuery = UploadBurgerHouseQuery(
            name: burgerHouse.name,
            totalRating: 0,
            hashtagName: "#" + burgerHouse.name,
            longitude: burgerHouse.x,
            latitude: burgerHouse.y,
            roadAddress: burgerHouse.roadAddress,
            phone: burgerHouse.phone,
            localId: burgerHouse.id,
            productId: LFRBProductID.burgerHouseTest.rawValue)
        
        localSearchUseCase.uploadBurgerHouseExecute(query: uploadBurgerHouseQuery)
            .asDriver(onErrorJustReturn: .failure(.unknown(message: R.Phrase.errorOccurred)))
            .drive(with: self) { owner, result in
                switch result {
                case .success(let value):
                    print("\(value.name) 서버 저장 완료")
                    var result = burgerHouse
                    result.burgerHousePostId = value.burgerHousePostId
                    owner.selectItem.accept(result)
                case .failure(let error):
                    switch error {
                    case .network(let message):
                        owner.toastMessage.accept(message)
                    case .invalidValue(let message):
                        owner.toastMessage.accept(message)
                    case .invalidToken(let message):
                        owner.toastMessage.accept(message)
                    case .forbidden(let message):
                        owner.toastMessage.accept(message)
                    case .dbServer(let message):
                        owner.toastMessage.accept(message)
                    case .expiredToken:
                        print("uploadBurgerHouseExecute 액세스 토큰 만료")
                    case .unknown(let message):
                        owner.toastMessage.accept(message)
                    }
                }
            } onCompleted: { _ in
                print("uploadBurgerHouseExecute completed")
            } onDisposed: { _ in
                print("uploadBurgerHouseExecute disposed")
            }
            .disposed(by: disposeBag)
    }
}
