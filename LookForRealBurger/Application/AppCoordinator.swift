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
    
    private var window: UIWindow!
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        startAuthCoordinator()
    }
}

extension AppCoordinator {
    func startAuthCoordinator() {
        let navigationController = UINavigationController()
        let authCoordinator = AuthCoordinator(navigationController: navigationController)

        childCoordinators.removeAll()
        childCoordinators.append(authCoordinator)
        
        authCoordinator.parentCoordinator = self
        authCoordinator.start()
        
        setRootViewController(navigationController)
    }
    
    func startMainTabbarCoordinator() {
        let mainTabbarCoordinator = MainTabbarCoordinator()
        
        childCoordinators.removeAll()
        childCoordinators.append(mainTabbarCoordinator)
        
        mainTabbarCoordinator.parentCoordinator = self
        
        let mainTabBarController = MainTabBar.create(coordinator: mainTabbarCoordinator)
        setRootViewController(mainTabBarController)
    }
}

extension AppCoordinator {
    private func setRootViewController(_ viewController: UIViewController) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
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
        let viewController = LoginScene.makeView()
        viewController.coordinator = self
        
        navigationController.viewControllers = [viewController]
    }
    
    func goToJoin() {
        let viewController = JoinScene.makeView()
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToJoinComplete(user: JoinUser) {
        let viewController = JoinScene.makeView(user: user)
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToMainTabbar() {
        guard let appCoordinator = parentCoordinator as? AppCoordinator else { return }
        appCoordinator.startMainTabbarCoordinator()
    }
}

final class MainTabbarCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init() {
        print("init -> \(String(describing: self))")
    }
    
    deinit {
        print("deinit -> \(String(describing: self))")
    }
    
    func start() { }
}

protocol MapNavigation: AnyObject {
    func goToLogin()
    func goToMap()
}

final class MapCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        goToMap()
    }
}

extension MapCoordinator: MapNavigation {
    func goToLogin() {
        guard let appCoordinator = parentCoordinator as? AppCoordinator else { return }
        appCoordinator.startAuthCoordinator()
    }
    
    func goToMap() {
        let viewController = BurgerMapScene.makeView()
        viewController.coordinator = self
        
        navigationController.viewControllers = [viewController]
    }
}

final class ReviewCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        goToReview()
    }
}

        
        guard let appCoordinator = parentCoordinator as? AppCoordinator else { return }
        appCoordinator.startAuthCoordinator()
    }
    
    func goToReview() {
        let viewController = BurgerHouseReviewScene.makeView(
            coordinator: self,
            getPostType: .total
        )
        navigationController.viewControllers = [viewController]
    }
    
    func goToDetail() {
        
    }
}

protocol WriteReviewNavigation: AnyObject {
    func goToWriteReview()
    func goToSearchBurgerHouse()
}

final class WriteReviewCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        goToWriteReview()
    }
}

extension WriteReviewCoordinator: WriteReviewNavigation {
    func goToLogin() {
        guard let appCoordinator = parentCoordinator as? AppCoordinator else { return }
        appCoordinator.startAuthCoordinator()
    }
    
    func goToWriteReview() {
        
    }
    
    func goToSearchBurgerHouse() {
        
    }
}

final class ProfileCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
    }
}

    func goToLogin() {
        guard let appCoordinator = parentCoordinator as? AppCoordinator else { return }
        appCoordinator.startAuthCoordinator()
    }
    
        let viewController = ProfileScene.makeView(
            coordinator: self,
        )
    }
    
        
    }
}
