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
    func didTapBack()
    func didChangeText(text: String)
    func searchText(type: RequestType, text: String)
    func modelSelected(item: BurgerHouse)
}

protocol SearchBurgerHouseOutput {
    var popView: PublishRelay<Void> { get }
    var isSearchEnabled: PublishRelay<Bool> { get }
    var burgerHouses: PublishRelay<[BurgerHouse]> { get }
    var toastMessage: PublishRelay<String> { get }
    var selectItem: PublishRelay<BurgerHouse> { get }
    var nextPage: Int { get }
    var isEndPage: Bool { get }
}

typealias SearchBurgerHouseViewModel = SearchBurgerHouseInput & SearchBurgerHouseOutput

final class DefaultSearchBurgerHouseViewModel: SearchBurgerHouseOutput {
    var popView = PublishRelay<Void>()
    var isSearchEnabled = PublishRelay<Bool>()
    var burgerHouses = PublishRelay<[BurgerHouse]>()
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
        
        let data = Observable.combineLatest(
            Observable.just(nextPage),
            Observable.just(text)
        )
        
        locationManager.coordinate
            .withLatestFrom(data) { (coordinate: $0, nextPage: $1.0, text: $1.1) }
            .map {
                LocalSearchQuery(
                    query: $0.text,
                    x: $0.coordinate.longitude,
                    y: $0.coordinate.latitude,
                    page: $0.nextPage
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
                            if owner.nextPage == 1 {
                                owner.burgerHouses.accept(value.burgerHouses)
                            } else {
                                
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
        selectItem.accept(item)
    }
}
