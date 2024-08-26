//
//  EmptyPresentViewController.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/24/24.
//

import UIKit

final class EmptyPresentViewController: BaseViewController {
    private var loginUseCase: LoginUseCase!
    
    static func create(loginUseCase: LoginUseCase) -> EmptyPresentViewController {
        let view = EmptyPresentViewController()
        view.loginUseCase = loginUseCase
        return view
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let vc = WriteReviewScene.makeView(
            tabBar: tabBarController ?? UITabBarController(),
            loginUseCase: loginUseCase
        )
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
