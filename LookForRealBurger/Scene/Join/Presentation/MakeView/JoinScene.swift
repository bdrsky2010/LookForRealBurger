//
//  JoinScene.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/21/24.
//

import UIKit

enum JoinScene {
    static func makeView(coordinator: LoginNavigation) -> JoinViewController {
        let authRepository = DefualtAuthRepository.shared
        let joinUseCase = DefaultJoinUseCase(authRepository: authRepository)
        let joinViewModel = DefaultLFRBJoinViewModel(joinUseCase: joinUseCase)
        let joinView = JoinViewController.create(
            coordinator: coordinator,
            with: joinViewModel
        )
        return joinView
    }
    
    static func makeView(
        coordinator: LoginNavigation,
        user: JoinUser
    ) -> JoinCompleteViewController {
        let joinCompleteView = JoinCompleteViewController.create(
            coordinator: coordinator,
            user: user
        )
        return joinCompleteView
    }
}
