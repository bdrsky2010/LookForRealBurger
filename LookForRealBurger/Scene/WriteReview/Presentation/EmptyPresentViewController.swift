//
//  EmptyPresentViewController.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/24/24.
//

import UIKit

final class EmptyPresentViewController: BaseViewController {
    private weak var coordinator: WriteReviewNavigation!
    
    static func create(coordinator: WriteReviewNavigation) -> EmptyPresentViewController {
        let view = EmptyPresentViewController()
        view.coordinator = coordinator
        return view
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        let vc = WriteReviewScene.makeView(
            tabBar: tabBarController
        )
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
