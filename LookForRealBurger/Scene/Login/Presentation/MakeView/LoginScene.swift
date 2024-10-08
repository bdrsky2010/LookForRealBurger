//
//  LoginScene.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/21/24.
//

import UIKit

enum LoginScene {
    static func makeView() -> LoginViewController {
        let authRepository = DefualtAuthRepository.shared
        let loginUseCase = DefaultLoginUseCase(authRepository: authRepository)
        let accessStorage = UserDefaultsAccessStorage.shared
        let viewModel = DefaultLoginViewModel(
            loginUseCase: loginUseCase,
            accessStorage: accessStorage
        )
        let view = LoginViewController.create(with: viewModel)
        return view
    }
}
