//
//  AppCoordinator.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 1/10/25.
//

import UIKit

final class AppCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        startAuthCoordinator()
    }
}

extension AppCoordinator {
    func startAuthCoordinator() {
        let authCoordinator = AuthCoordinator(navigationController: navigationController)

        childCoordinators.removeAll()
        childCoordinators.append(authCoordinator)
        
        authCoordinator.parentCoordinator = self
        authCoordinator.start()
    }
    
protocol LoginNavigation: AnyObject {
    func goToJoin()
    func goToJoinComplete(user: JoinUser)
    func goToMainTabbar()
}

final class AuthCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        print("init -> \(String(describing: self))")
    }
    
    deinit {
        print("deinit -> \(String(describing: self))")
    }
    
    func start() {
        let viewController = LoginScene.makeView(coordinator: self)
        navigationController.viewControllers = [viewController]
    }
}

extension AuthCoordinator: LoginNavigation {
    func goToJoin() {
        let viewController = JoinScene.makeView(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToJoinComplete(user: JoinUser) {
        let viewController = JoinScene.makeView(coordinator: self, user: user)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToMainTabbar() {
        
    }
}
