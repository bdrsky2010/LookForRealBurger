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
    func goToLogin()
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
        goToLogin()
    }
}

extension AuthCoordinator: LoginNavigation {
    func goToLogin() {
        let viewController = LoginScene.makeView(coordinator: self)
        navigationController.viewControllers = [viewController]
    }
    
    func goToJoin() {
        let viewController = JoinScene.makeView(coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToJoinComplete(user: JoinUser) {
        let viewController = JoinScene.makeView(coordinator: self, user: user)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToMainTabbar() {

protocol MapNavigation: AnyObject {
    
}

final class MapCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = []
    
    func start() {
        
    }
}

extension MapCoordinator: MapNavigation {
    
}

protocol ReviewNavigation: AnyObject {
    
}

final class ReviewCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = []
    
    func start() {
        
    }
}

extension ReviewCoordinator: ReviewNavigation {
    
}

protocol WriteReviewNavigation: AnyObject {
    
}

final class WriteReviewCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = []
    
    func start() {
        
    }
}

extension WriteReviewCoordinator: WriteReviewNavigation {
    
}

protocol ProfileNavigation: AnyObject {
    
}

final class ProfileCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = []
    
    func start() {
        
    }
}

extension ProfileCoordinator: ProfileNavigation {
    
}
