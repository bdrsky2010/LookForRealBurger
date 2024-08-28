//
//  BurgerMapScene.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/28/24.
//

import Foundation

enum BurgerMapScene {
    static func makeView() -> BurgerMapViewController {
        let locationManager = DefaultLocationManager.shared
        let postRepository = DefaultPostRepository.shared
        let authRepository = DefualtAuthRepository.shared
        let burgerMapUseCase = DefaultBurgerMapUseCase(
            postRepository: postRepository,
            authRepository: authRepository
        )
        let accessStorage = UserDefaultsAccessStorage.shared
        let viewModel = DefaultBurgerMapViewModel(
            locationManager: locationManager,
            burgerMapUseCase: burgerMapUseCase,
            accessStorage: accessStorage
        )
        let view = BurgerMapViewController.create(viewModel: viewModel)
        return view
    }
}
