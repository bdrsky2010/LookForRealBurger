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
        let postRepository = DefaultPostRepository.shared
        let commentRepository = DefaultCommentRepository.shared
        let postUploadUseCase = DefaultUploadPostUseCase(
            postRepository: postRepository,
            commentRepository: commentRepository
        )
        let viewModel = DefaultWriteReviewViewModel(
            loginUseCase: loginUseCase,
            postUploadUseCase: postUploadUseCase
        )
        let view = WriteReviewViewController.create(
            tabBar: tabBar,
            viewModel: viewModel
        )
        return view
    }
    
    static func makeView() -> SearchBurgerHouseViewController {
        let localSearchRepository = KakaoLocalSearchRepository()
        let postRepository = DefaultPostRepository.shared
        let localSearchUseCase = DefaultLocalSearchUseCase(
            localSearchRepository: localSearchRepository,
            postRepository: postRepository
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
