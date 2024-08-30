//
//  MainTabBar.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/22/24.
//

import UIKit

import RxCocoa
import RxSwift

private enum TabItem: CaseIterable {
    case map
    case review
    case writeReview
    case profile
    
    var viewController: UIViewController {
        let view: BaseViewController
        
        switch self {
        case .map:
            view = BurgerMapScene.makeView()
        case .review:
            view = BurgerHouseReviewScene.makeView()
        case .writeReview:
            view = EmptyPresentViewController()
        case .profile:
            view = MyProfileViewController()
        }
        
        let nav = UINavigationController()
        nav.pushViewController(view, animated: false)
        return nav
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
        case .map:         "버거맵"
        case .review:      "리뷰"
        case .writeReview: "리뷰추가"
        case .profile:     "프로필"
        }
    }
}

final class MainTabBar: UITabBarController {
    private var loginUseCase: LoginUseCase!
    private var disposeBag: DisposeBag!
    
    static func create(
        loginUseCase: LoginUseCase,
        disposeBag: DisposeBag = DisposeBag()
    ) -> UITabBarController {
        let view = MainTabBar()
        view.loginUseCase = loginUseCase
        
        var viewControllers = [UIViewController]()
        
        TabItem.allCases.forEach { item in
            let vc = item.viewController
            vc.tabBarItem.imageInsets = .init(top: 0, left: 0, bottom: -6, right: 0)
            vc.tabBarItem.image = item.image
            vc.tabBarItem.selectedImage = item.selectedImage
            vc.tabBarItem.title = item.title
            viewControllers.append(vc)
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
        
        view.tabBar.standardAppearance = tabBarAppearance
        view.tabBar.scrollEdgeAppearance = tabBarAppearance
        
        view.tabBar.layer.masksToBounds = false
        view.tabBar.layer.shadowColor = UIColor.gray.cgColor
        view.tabBar.layer.shadowOpacity = 0.3
        view.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.tabBar.layer.shadowRadius = 6
        
        view.setViewControllers(viewControllers, animated: true)
        
        return view
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
