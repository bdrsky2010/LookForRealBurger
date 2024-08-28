//
//  BurgerMapViewModel.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/23/24.
//

import Foundation
import CoreLocation

import RxCocoa
import RxSwift

protocol BurgerMapInput {
    func viewWillAppear()
    func viewDidLoad()
    func refreshAccessToken(completion: @escaping () -> Void)
}

protocol BurgerMapOutput {
    var requestAuthAlert: PublishRelay<String> { get }
    var setRegion: PublishRelay<CLLocationCoordinate2D> { get }
    var burgerMapHouses: PublishRelay<[BurgerMapHouse]> { get }
    var toastMessage: PublishRelay<String> { get }
    var goToLogin: PublishRelay<Void> { get }
}

typealias BurgerMapViewModel = BurgerMapInput & BurgerMapOutput

final class DefaultBurgerMapViewModel: BurgerMapOutput {
    private let locationManager: LocationManager
    private let burgerMapUseCase: BurgerMapUseCase
    private let accessStorage: AccessStorage
    private let disposeBag: DisposeBag
    
    var requestAuthAlert = PublishRelay<String>()
    var setRegion = PublishRelay<CLLocationCoordinate2D>()
    var burgerMapHouses = PublishRelay<[BurgerMapHouse]>()
    var toastMessage = PublishRelay<String>()
    var goToLogin = PublishRelay<Void>()
    
    init(
        locationManager: LocationManager,
        burgerMapUseCase: BurgerMapUseCase,
        accessStorage: AccessStorage,
        disposeBag: DisposeBag = DisposeBag()
    ) {
        self.locationManager = locationManager
        self.burgerMapUseCase = burgerMapUseCase
        self.accessStorage = accessStorage
        self.disposeBag = disposeBag
    }
}

extension DefaultBurgerMapViewModel: BurgerMapInput {
    func viewWillAppear() {
        locationManager.requestAuthAlert
            .bind(to: requestAuthAlert)
            .disposed(by: disposeBag)
        
        locationManager.checkDeviceLocationAuthorization()
        
        locationManager.coordinate
            .bind(to: setRegion)
            .disposed(by: disposeBag)
    }
    
    func viewDidLoad() {
        burgerMapUseCase.fetchBurgerHouseExecute(
            query: .init(
                next: nil,
                limit: "300000",
                productId: LFRBProductID.burgerHouseTest.rawValue
            )
        )
        .asDriver(onErrorJustReturn: .failure(.unknown(R.Phrase.errorOccurred)))
        .drive(with: self) { owner, result in
            switch result {
            case .success(let value):
                print("성공 \(value)")
                owner.burgerMapHouses.accept(value)
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
                    owner.refreshAccessToken {
                        owner.viewDidLoad()
                    }
                case .unknown(let message):
                    owner.toastMessage.accept(message)
                case .invalidValue(_):
                    break
                case .dbServer(_):
                    break
                }
            }
        } onCompleted: { _ in
            print("fetchBurgerHouseExecute completed")
        } onDisposed: { _ in
            print("fetchBurgerHouseExecute disposed")
        }
        .disposed(by: disposeBag)
    }
    
    func refreshAccessToken(completion: @escaping () -> Void) {
        burgerMapUseCase.refreshAccessTokenExecute()
            .asDriver(onErrorJustReturn: .failure(.unknown(R.Phrase.errorOccurred)))
            .drive(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.accessStorage.accessToken = value.accessToken
                    completion()
                case .failure(let error):
                    switch error {
                    case .network(let message):
                        owner.toastMessage.accept(message)
                    case .missingFields:
                        break
                    case .accountVerify:
                        break
                    case .invalidToken(let message):
                        owner.toastMessage.accept(message)
                    case .forbidden(let message):
                        owner.toastMessage.accept(message)
                    case .unknown(let message):
                        owner.toastMessage.accept(message)
                    case .existBlank:
                        break
                    case .existUser:
                        break
                    case .enable:
                        break
                    case .expiredRefreshToken:
                        owner.goToLogin.accept(())
                    case .expiredAccessToken:
                        break
                    }
                }
            } onCompleted: { _ in
                print("refreshAccessTokenExecute completed")
            } onDisposed: { _ in
                print("refreshAccessTokenExecute disposed")
            }
            .disposed(by: disposeBag)
    }
}
