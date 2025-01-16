//
//  MainTabBar.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/22/24.
//

import UIKit

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
            let writeReviewCoordinator = WriteReviewCoordinator()
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

final class MainTabBar: UITabBarController {
    private weak var coordinator: MainTabbarCoordinator!
    
    static func create(coordinator: MainTabbarCoordinator) -> UITabBarController {
        let tabBarController = MainTabBar()
        var viewControllers = [UIViewController]()
        
        TabItem.allCases.forEach { item in
            guard let parentCoordinator = coordinator.parentCoordinator else { return }
            let viewController = item.setupViewController(parentCoordinator: parentCoordinator)
            viewController.tabBarItem.imageInsets = .init(top: 0, left: 0, bottom: -6, right: 0)
            viewController.tabBarItem.image = item.image
            viewController.tabBarItem.selectedImage = item.selectedImage
            viewController.tabBarItem.title = item.title
            viewControllers.append(viewController)
        }
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = R.Color.brown
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            NSAttributedString.Key.font: R.Font.chab13,
            NSAttributedString.Key.foregroundColor: R.Color.brown
        ]
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = R.Color.red
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            NSAttributedString.Key.font: R.Font.chab13,
            NSAttributedString.Key.foregroundColor: R.Color.red
        ]
        tabBarAppearance.backgroundColor = R.Color.background
        
        tabBarController.tabBar.standardAppearance = tabBarAppearance
        tabBarController.tabBar.scrollEdgeAppearance = tabBarAppearance
        
        tabBarController.tabBar.layer.masksToBounds = false
        tabBarController.tabBar.layer.shadowColor = UIColor.gray.cgColor
        tabBarController.tabBar.layer.shadowOpacity = 0.3
        tabBarController.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBarController.tabBar.layer.shadowRadius = 6
        
        tabBarController.setViewControllers(viewControllers, animated: true)
        
        return tabBarController
    }
    
    deinit {
        print("deinit -> \(String(describing: self))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
}

extension MainTabBar: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        UITabBarController.previousSelectedIndex = tabBarController.selectedIndex
        return true
    }
}
