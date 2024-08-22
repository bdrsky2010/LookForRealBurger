//
//  LoginScene.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/21/24.
//

import UIKit

enum LoginScene {
    static func makeView() -> LoginViewController {
        let network = LFRBNetworkManager.shared
        let tokenStorage = UserDefaultsAccessTokenStorage.shared
        let loginService = DefaultLoginService(
            network: network,
            tokenStorage: tokenStorage
        )
        let useCase = DefaultLoginUseCase(loginService: loginService)
        let viewModel = DefaultLoginViewModel(useCase: useCase)
        let view = LoginViewController.create(with: viewModel)
        return view
    }
}
