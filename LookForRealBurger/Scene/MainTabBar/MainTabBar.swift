//
//  MainTabBar.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/22/24.
//

import UIKit

private enum TabItem: CaseIterable {
    static var allCases = [TabItem]()
    
    case map(loginUseCase: LoginUseCase)
    case review(loginUseCase: LoginUseCase)
    case writeReview(loginUseCase: LoginUseCase)
    case profile(loginUseCase: LoginUseCase)
    
    var viewController: UIViewController {
        switch self {
        case .map(let loginUseCase):
            return BurgerMapViewController()
        case .review(let loginUseCase):
            return BurgerReviewViewController()
        case .writeReview(let loginUseCase):
            return WriteReviewViewController()
        case .profile(let loginUseCase):
            return MyProfileViewController()
        }
    }
    
    var image: UIImage? {
        switch self {
        case .map:
            UIImage(systemName: "map.fill")
        case .review:
            UIImage(systemName: "list.clipboard.fill")
        case .writeReview:
            UIImage(systemName: "pencil.and.list.clipboard")
        case .profile:
            UIImage(systemName: "person.crop.circle.fill")
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .map:
            UIImage(systemName: "map.fill")
        case .review:
            UIImage(systemName: "list.clipboard.fill")
        case .writeReview:
            UIImage(systemName: "pencil.and.list.clipboard")
        case .profile:
            UIImage(systemName: "person.crop.circle.fill")
        }
    }
}

final class MainTabBar: UITabBarController {
    private var loginUseCase: LoginUseCase!
    
    static func create(loginUseCase: LoginUseCase) -> UITabBarController {
        let view = MainTabBar()
        view.loginUseCase = loginUseCase
        TabItem.allCases.append(
            contentsOf: [
                .map(loginUseCase: loginUseCase),
                .review(loginUseCase: loginUseCase),
                .writeReview(loginUseCase: loginUseCase),
                .profile(loginUseCase: loginUseCase)
            ]
        )
        
        var viewControllers: [UIViewController] = []
        
        TabItem.allCases.forEach { item in
            let vc = item.viewController
            vc.tabBarItem.image = item.image
            vc.tabBarItem.selectedImage = item.selectedImage
            viewControllers.append(vc)
        }
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = R.Color.brown
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = R.Color.red
        tabBarAppearance.backgroundColor = R.Color.background
        
        view.tabBar.standardAppearance = tabBarAppearance
        view.tabBar.scrollEdgeAppearance = tabBarAppearance
        
        // set tabbar shadow
        view.tabBar.layer.masksToBounds = false
        view.tabBar.layer.shadowColor = UIColor.gray.cgColor
        view.tabBar.layer.shadowOpacity = 0.3
        view.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.tabBar.layer.shadowRadius = 6
        
        view.setViewControllers(viewControllers, animated: true)
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
