//
//  FollowListTabViewController.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/2/24.
//

import UIKit

import Tabman
import Pageboy

enum FollowType: Int {
    case follow
    case following
}

final class FollowListTabViewController: TabmanViewController {
    private var viewControllers: [UIViewController]
    
    private let followType: FollowType
    private let myUserId: String
    private let followers: [GetFollow]
    private let followings: [GetFollow]
    
    private weak var coordinator: ReviewProfileNavigation!
    
    init(
        coordinator: ReviewProfileNavigation,
        viewControllers: [UIViewController] = [],
        followType: FollowType,
        myUserId: String,
        followers: [GetFollow],
        followings: [GetFollow]
    ) {
        self.coordinator = coordinator
        self.viewControllers = viewControllers
        self.followType = followType
        self.myUserId = myUserId
        self.followers = followers
        self.followings = followings
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let followersView = ProfileScene.makeView(myUserId: myUserId, followList: followers)
        followersView.coordinator = coordinator
        
        let followingsView = ProfileScene.makeView(myUserId: myUserId, followList: followings)
        followingsView.coordinator = coordinator
        
        viewControllers.append(followersView)
        viewControllers.append(followingsView)
        
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

extension FollowListTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: any Tabman.TMBar, at index: Int) -> any Tabman.TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: R.Phrase.follower)
        case 1:
            return TMBarItem(title: R.Phrase.following)
        default:
            let title = "Page \(index)"
            return TMBarItem(title: title)
        }
    }
    
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        viewControllers.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return .at(index: followType.rawValue)
    }
}
