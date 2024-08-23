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
        let accessStorage = UserDefaultsAccessStorage.shared
        let loginRepository = DefaultLoginRepository(
            network: network,
            accessStorage: accessStorage
        )
        let useCase = DefaultLoginUseCase(loginRepository: loginRepository)
        let viewModel = DefaultLoginViewModel(useCase: useCase)
        let view = LoginViewController.create(with: viewModel)
        return view
    }
}
