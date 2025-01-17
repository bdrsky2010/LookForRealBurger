//
//  TabManViewController.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/1/24.
//

import UIKit

import Tabman
import Pageboy

final class ProfileReviewTabViewController: TabmanViewController {
    private weak var coordinator: ReviewProfileNavigation!
    private var viewControllers: [UIViewController]
    private let profileType: ProfileType
    
    init(
        coordinator: ReviewProfileNavigation?,
        viewControllers: [UIViewController] = [],
        profileType: ProfileType
    ) {
        self.coordinator = coordinator
        self.viewControllers = viewControllers
        self.profileType = profileType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch profileType {
        case .me:
            let myReview = BurgerHouseReviewScene.makeView(
                getPostType: .byUser(UserDefaultsAccessStorage.shared.loginUserId)
            )
            myReview.coordinator = coordinator
            
            let myLikeReview = BurgerHouseReviewScene.makeView(
                getPostType: .myLike
            )
            myLikeReview.coordinator = coordinator
            
            let myBookmarkReview = BurgerHouseReviewScene.makeView(
                getPostType: .myLike2
            )
            myBookmarkReview.coordinator = coordinator
            
            viewControllers.append(myReview)
            viewControllers.append(myLikeReview)
            viewControllers.append(myBookmarkReview)
        case .other(let userId, _):
            let userReview = BurgerHouseReviewScene.makeView(
                getPostType: .byUser(userId)
            )
            userReview.coordinator = coordinator
            
            viewControllers.append(userReview)
        }
        
        dataSource = self
        
        let bar = TMBar.ButtonBar()
              
        bar.backgroundView.style = .clear
        bar.backgroundColor = R.Color.background
        
        
        bar.layout.transitionStyle = .snap
        
        bar.indicator.weight = .custom(value: 1)
        bar.indicator.tintColor = R.Color.orange
        
        bar.layout.alignment = .centerDistributed
        
        bar.layout.contentMode = .fit
        
        bar.buttons.customize{ (button) in
            button.tintColor = R.Color.brown
            button.selectedTintColor = R.Color.red
            button.font = R.Font.chab20
        }
        
        addBar(bar, dataSource: self, at: .top)
    
        bar.indicator.overscrollBehavior = .bounce
    }
}

extension ProfileReviewTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: any Tabman.TMBar, at index: Int) -> any Tabman.TMBarItemable {
        switch profileType {
        case .me:
            switch index {
            case 0:
                return TMBarItem(title: R.Phrase.review)
            case 1:
                return TMBarItem(title: R.Phrase.like)
            case 2:
                return TMBarItem(title: R.Phrase.bookmark)
            default:
                let title = "Page \(index)"
                return TMBarItem(title: title)
            }
        case .other:
            switch index {
            case 0:
                return TMBarItem(title: R.Phrase.review)
            default:
                let title = "Page \(index)"
                return TMBarItem(title: title)
            }
        }
    }
    
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        viewControllers.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return nil
    }
}
