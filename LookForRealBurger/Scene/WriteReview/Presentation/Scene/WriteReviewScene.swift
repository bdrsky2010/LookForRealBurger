//
//  WriteReviewScene.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/25/24.
//

import UIKit

enum WriteReviewScene {
    static func makeView(loginUseCase: LoginUseCase) -> EmptyPresentViewController {
        let view = EmptyPresentViewController.create(loginUseCase: loginUseCase)
        return view
    }
    
    static func makeView(
        tabBar: UITabBarController,
        loginUseCase: LoginUseCase
    ) -> WriteReviewViewController {
        let network = LFRBNetworkManager.shared
        let imageUploadRepository = DefaultImageUploadRepository(network: network)
        let postUploadRepository = DefaultPostUploadRepository(network: network)
        let postUploadUseCase = DefaultPostUploadUseCase(
            imageUploadRepository: imageUploadRepository,
            postUploadRepository: postUploadRepository
        )
        let viewModel = DefaultWriteReviewViewModel(loginUseCase: loginUseCase, postUploadUseCase: postUploadUseCase)
        let view = WriteReviewViewController.create(tabBar: tabBar, viewModel: viewModel)
        return view
    }
    
    static func makeView() -> SearchBurgerHouseViewController {
        let localSearchRepository = KakaoLocalSearchRepository()
        let localSearchUseCase = DefaultLocalSearchUseCase(localSearchRepository: localSearchRepository)
        let locationManager = DefaultLocationManager.shared
        let viewModel = DefaultSearchBurgerHouseViewModel(
            localSearchUseCase: localSearchUseCase,
            locationManager: locationManager
        )
        let view = SearchBurgerHouseViewController.create(viewModel: viewModel)
        return view
    }
}
