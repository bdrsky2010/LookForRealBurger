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
        let uploadPostRepository = DefaultUploadPostRepository(network: network)
        let postUploadUseCase = DefaultUploadPostUseCase(
            imageUploadRepository: imageUploadRepository,
            uploadPostRepository: uploadPostRepository
        )
        let viewModel = DefaultWriteReviewViewModel(
            loginUseCase: loginUseCase,
            postUploadUseCase: postUploadUseCase
        )
        let view = WriteReviewViewController.create(
            tabBar: tabBar,
            viewModel: viewModel,
            uploadPostRepository: uploadPostRepository
        )
        return view
    }
    
    static func makeView(uploadPostRepository: UploadPostRepository) -> SearchBurgerHouseViewController {
        let network = LFRBNetworkManager.shared
        let localSearchRepository = KakaoLocalSearchRepository()
        let getPostRepository = DefaultGetPostRepository(network: network)
        let localSearchUseCase = DefaultLocalSearchUseCase(
            localSearchRepository: localSearchRepository,
            getPostRepository: getPostRepository,
            uploadPostRepository: uploadPostRepository
        )
        let locationManager = DefaultLocationManager.shared
        let viewModel = DefaultSearchBurgerHouseViewModel(
            localSearchUseCase: localSearchUseCase,
            locationManager: locationManager
        )
        let view = SearchBurgerHouseViewController.create(viewModel: viewModel)
        return view
    }
}
