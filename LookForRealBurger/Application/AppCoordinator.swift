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

extension ReviewCoordinator: ReviewProfileNavigation {
    func goToReview() {
        let viewController = BurgerHouseReviewScene.makeView(getPostType: .total)
        viewController.coordinator = self
        
        navigationController.viewControllers = [viewController]
    }
    
    func goToLogin() {
        guard let appCoordinator = parentCoordinator as? AppCoordinator else { return }
        appCoordinator.startAuthCoordinator()
    }
    
    func goToReviewDetail(burgerHouseReview: BurgerHouseReview) {
        let viewController = BurgerHouseReviewScene.makeView(
            burgerHouseReview: burgerHouseReview
        )
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToProfile(profileType: ProfileType) {
        let viewController = ProfileScene.makeView(
            profileType: profileType
        )
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToFollow(
        followType: FollowType,
        myUserId: String,
        followers: [GetFollow],
        followings: [GetFollow]
    ) {
        let viewController = ProfileScene.makeView(
            coordinator: self,
            followType: followType,
            myUserId: myUserId,
            followers: followers,
            followings: followings
        )
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToMore() {
        let viewController = MoreViewController()
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToBack() {
        navigationController.popViewController(animated: true)
    }
}

protocol WriteReviewNavigation: AnyObject {
    func goToWriteReview()
}

final class WriteReviewCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    
    
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
        goToMyProfile()
    }
}

extension ProfileCoordinator: ReviewProfileNavigation {
    func goToMyProfile() {
        let viewController = ProfileScene.makeView(
            profileType: .me(UserDefaultsAccessStorage.shared.loginUserId)
        )
        navigationController.viewControllers = [viewController]
    }
    
    func goToLogin() {
        guard let appCoordinator = parentCoordinator as? AppCoordinator else { return }
        appCoordinator.startAuthCoordinator()
    }
    
    func goToReviewDetail(burgerHouseReview: BurgerHouseReview) {
        let viewController = BurgerHouseReviewScene.makeView(
            burgerHouseReview: burgerHouseReview
        )
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToProfile(profileType: ProfileType) {
        let viewController = ProfileScene.makeView(
            profileType: profileType
        )
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToFollow(
        followType: FollowType,
        myUserId: String,
        followers: [GetFollow],
        followings: [GetFollow]
    ) {
        let viewController = ProfileScene.makeView(
            coordinator: self,
            followType: followType,
            myUserId: myUserId,
            followers: followers,
            followings: followings
        )
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToMore() {
        let viewController = MoreViewController()
        viewController.coordinator = self
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func goToBack() {
        navigationController.popViewController(animated: true)
    }
}

protocol ReviewProfileNavigation: AnyObject {
    func goToLogin()
    func goToReviewDetail(burgerHouseReview: BurgerHouseReview)
    func goToProfile(profileType: ProfileType)
    func goToFollow(
        followType: FollowType,
        myUserId: String,
        followers: [GetFollow],
        followings: [GetFollow]
    )
    func goToMore()
    func goToBack()
}
