//
//  LoginScene.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/21/24.
//

import UIKit

enum LoginScene {
    static func makeView(coordinator: LoginNavigation) -> LoginViewController {
        let authRepository = DefualtAuthRepository.shared
        let loginUseCase = DefaultLoginUseCase(authRepository: authRepository)
        let accessStorage = UserDefaultsAccessStorage.shared
        let viewModel = DefaultLoginViewModel(
            loginUseCase: loginUseCase,
            accessStorage: accessStorage
        )
        let view = LoginViewController.create(
            coordinator: coordinator,
            with: viewModel
        )
        return view
    }
}
