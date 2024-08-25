//
//  BurgerMapViewModel.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/23/24.
//

import Foundation

import RxCocoa
import RxSwift

protocol BurgerMapInput {
    func viewDidLoad()
}

protocol BurgerMapOutput {
    var requestAuthAlert: PublishRelay<String> { get }
}

typealias BurgerMapViewModel = BurgerMapInput & BurgerMapOutput

final class DefaultBurgerMapViewModel: BurgerMapOutput {
    private let locationManager: LocationManager
    private let disposeBag: DisposeBag
    
    var requestAuthAlert = PublishRelay<String>()
    
    init(
        locationManager: LocationManager,
        disposeBag: DisposeBag = DisposeBag()
    ) {
        self.locationManager = locationManager
        self.disposeBag = disposeBag
    }
}

extension DefaultBurgerMapViewModel: BurgerMapInput {
    func viewDidLoad() {
        locationManager.requestAuthAlert
            .bind(to: requestAuthAlert)
            .disposed(by: disposeBag)
    }
}
