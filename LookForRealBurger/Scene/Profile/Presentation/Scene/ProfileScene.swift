//
//  ProfileScene.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/1/24.
//

import Foundation

enum ProfileScene {
    static func makeView(profileType: ProfileType) -> ProfileViewController {
        let profileRepository = DefualtProfileRepository.shared
        let authRepository = DefualtAuthRepository.shared
        let profileUseCase = DefaultProfileUseCase(
            profileRepository: profileRepository,
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
}
