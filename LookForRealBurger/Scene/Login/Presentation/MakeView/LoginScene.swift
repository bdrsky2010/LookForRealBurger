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
        let useCase = DefaultLoginUseCase(authRepository: authRepository)
        let viewModel = DefaultLoginViewModel(useCase: useCase)
        let view = LoginViewController.create(with: viewModel)
        return view
    }
}
