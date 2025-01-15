//
//  WriteReviewScene.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/25/24.
//

import UIKit

enum WriteReviewScene {
    static func makeView(
        coordinator: WriteReviewNavigation
    ) -> WriteReviewViewController {
        let postRepository = DefaultPostRepository.shared
        let commentRepository = DefaultCommentRepository.shared
        let authRepository = DefualtAuthRepository.shared
        let uploadPostUseCase = DefaultUploadPostUseCase(
            postRepository: postRepository,
            commentRepository: commentRepository,
            authRepository: authRepository
        )
        let accessStorage = UserDefaultsAccessStorage.shared
        let viewModel = DefaultWriteReviewViewModel(
            uploadPostUseCase: uploadPostUseCase,
            accessStorage: accessStorage
        )
        let view = WriteReviewViewController.create(
            coordinator: coordinator,
            viewModel: viewModel
        )
        return view
    }
    
    static func makeView() -> SearchBurgerHouseViewController {
        let localSearchRepository = KakaoLocalSearchRepository()
        let postRepository = DefaultPostRepository.shared
        let authRepository = DefualtAuthRepository.shared
        let localSearchUseCase = DefaultLocalSearchUseCase(
            localSearchRepository: localSearchRepository,
            postRepository: postRepository,
            authRepository: authRepository
        )
        let locationManager = DefaultLocationManager.shared
        let accessStorage = UserDefaultsAccessStorage.shared
        let viewModel = DefaultSearchBurgerHouseViewModel(
            localSearchUseCase: localSearchUseCase,
            locationManager: locationManager,
            accessStorage: accessStorage
        )
        let view = SearchBurgerHouseViewController.create(viewModel: viewModel)
        return view
    }
}
