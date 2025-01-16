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
        
    }
    
    func goToMap() {
        let viewController = BurgerMapScene.makeView(coordinator: self)
        navigationController.viewControllers = [viewController]
    }
}

protocol ReviewNavigation: AnyObject {
    func goToLogin()
    func goToReview()
    func goToDetail()
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

extension ReviewCoordinator: ReviewNavigation {
    func goToLogin() {
        
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
    func goToWriteReview() {
        
    }
    
    func goToSearchBurgerHouse() {
        
    }
}

protocol ProfileNavigation: AnyObject {
    func goToProfile()
    func goToReviewDetail()
}

final class ProfileCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        goToProfile()
    }
}

extension ProfileCoordinator: ProfileNavigation {
    func goToProfile() {
        let viewController = ProfileScene.makeView(
            coordinator: self,
            profileType: .me(UserDefaultsAccessStorage.shared.loginUserId)
        )
        navigationController.viewControllers = [viewController]
    }
    
    func goToReviewDetail() {
        
    }
}
