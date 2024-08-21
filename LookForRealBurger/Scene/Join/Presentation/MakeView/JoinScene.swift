//
//  JoinScene.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/21/24.
//

import UIKit

enum JoinScene {
    static func makeView() -> JoinViewController {
        let network = LFRBNetworkManager.shared
        let joinRepository = DefaultJoinRepository(network: network)
        let emailValidRepository = DefaultEmailValidRepository(network: network)
        let joinUseCase = DefaultJoinUseCase(joinRepository: joinRepository, emailValidRepository: emailValidRepository)
        let joinViewModel = DefaultLFRBJoinViewModel(joinUseCase: joinUseCase)
        let joinView = JoinViewController.create(with: joinViewModel)
        return joinView
    }
    
    static func makeView(user: JoinUser) -> JoinCompleteViewController {
        let joinCompleteView = JoinCompleteViewController.create(user: user)
        return joinCompleteView
    }
}
