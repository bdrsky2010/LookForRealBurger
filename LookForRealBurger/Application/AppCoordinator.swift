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
final class MainTabbarCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    
    init() {
        print("init -> \(String(describing: self))")
    }
    
    deinit {
        print("deinit -> \(String(describing: self))")
    }
    
    func start() {
        goToMain()
    }
}

extension MainTabbarCoordinator {
    private func goToMain() {
        let tabbar = MainTabBar()
        
        var viewControllers = [UIViewController]()
        
        TabItem.allCases.forEach { [weak parentCoordinator] item in
            guard let parentCoordinator else { return }
            let viewController = item.setupViewController(parentCoordinator: parentCoordinator)
            viewController.tabBarItem.imageInsets = .init(top: 0, left: 0, bottom: -6, right: 0)
            viewController.tabBarItem.image = item.image
            viewController.tabBarItem.selectedImage = item.selectedImage
            viewController.tabBarItem.title = item.title
            viewControllers.append(viewController)
        }
    }
}

private enum TabItem: CaseIterable {
    case map
    case review
    case writeReview
    case profile
    
    func setupViewController(parentCoordinator: Coordinator) -> UIViewController {
        let navigationController = UINavigationController()
        
        switch self {
        case .map:
            let mapCoordinator = MapCoordinator(navigationController: navigationController)
            mapCoordinator.parentCoordinator = parentCoordinator
            
            parentCoordinator.childCoordinators.append(mapCoordinator)
            
            mapCoordinator.start()
            
        case .review:
            let reviewCoordinator = ReviewCoordinator(navigationController: navigationController)
            reviewCoordinator.parentCoordinator = parentCoordinator
            
            parentCoordinator.childCoordinators.append(reviewCoordinator)
            
            reviewCoordinator.start()
            
        case .writeReview:
            let writeReviewCoordinator = WriteReviewCoordinator(navigationController: navigationController)
            writeReviewCoordinator.parentCoordinator = parentCoordinator
            parentCoordinator.childCoordinators.append(writeReviewCoordinator)
            
            let emptyViewController = EmptyPresentViewController.create(coordinator: writeReviewCoordinator)
            return emptyViewController
            
        case .profile:
            let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
            profileCoordinator.parentCoordinator = parentCoordinator
            
            parentCoordinator.childCoordinators.append(profileCoordinator)
            
            profileCoordinator.start()
        }
        
        return navigationController
    }
    
    var image: UIImage? {
        switch self {
        case .map:         UIImage(named: "burgerFlag")
        case .review:      UIImage(systemName: "list.clipboard.fill")
        case .writeReview: UIImage(systemName: "pencil.and.list.clipboard")
        case .profile:     UIImage(systemName: "person.crop.circle.fill")
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .map:         UIImage(named: "burgerFlag")
        case .review:      UIImage(systemName: "list.clipboard.fill")
        case .writeReview: UIImage(systemName: "pencil.and.list.clipboard")
        case .profile:     UIImage(systemName: "person.crop.circle.fill")
        }
    }
    
    var title: String {
        switch self {
        case .map:         R.Phrase.burgerMap
        case .review:      R.Phrase.review
        case .writeReview: R.Phrase.writeReview
        case .profile:     R.Phrase.profile
        }
    }
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
