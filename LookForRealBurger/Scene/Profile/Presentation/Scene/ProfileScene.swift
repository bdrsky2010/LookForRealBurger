//
//  ProfileScene.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/1/24.
//

import Foundation

enum ProfileScene {
    static func makeView(profileType: ProfileType) -> ProfileViewController {
        let profileRepository = DefaultProfileRepository.shared
        let followRepository = DefaultFollowRepository.shared
        let authRepository = DefualtAuthRepository.shared
        let profileUseCase = DefaultProfileUseCase(
            profileRepository: profileRepository,
            followRepository: followRepository,
            authRepository: authRepository
        )
        let accessStorage = UserDefaultsAccessStorage.shared
        let viewModel = DefaultProfileViewModel(
            ProfileUseCase: profileUseCase,
            accessStorage: accessStorage,
            profileType: profileType
        )
        let view = ProfileViewController.create(
            viewModel: viewModel,
            profileType: profileType
        )
        return view
    }
    
    static func makeView(
        myUserId: String,
        followList: [GetFollow]
    ) -> FollowListViewController {
        let viewModel = DefaultFollowListViewModel(
            myUserId: myUserId,
            followList: followList
        )
        let view = FollowListViewController.create(viewModel: viewModel)
        return view
    }
    
    static func makeView(
        coordinator: ReviewProfileNavigation,
        followType: FollowType,
        myUserId: String,
        followers: [GetFollow],
        followings: [GetFollow]
    ) -> FollowViewController {
        let view = FollowViewController.create(followListTabView: FollowListTabViewController(
            coordinator: coordinator,
            followType: followType,
            myUserId: myUserId,
            followers: followers,
            followings: followings
            )
        )
        return view
    }
}
