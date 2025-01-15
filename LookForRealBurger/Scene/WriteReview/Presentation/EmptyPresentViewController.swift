//
//  EmptyPresentViewController.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/24/24.
//

import UIKit

final class EmptyPresentViewController: BaseViewController {
    private weak var coordinator: WriteReviewCoordinator!
    
    static func create(coordinator: WriteReviewCoordinator) -> EmptyPresentViewController {
        let view = EmptyPresentViewController()
        view.coordinator = coordinator
        return view
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        let navigationController = UINavigationController()
        coordinator.initNavigationController(navigationController: navigationController)
        coordinator.delegate = self
        coordinator.start()
        present(navigationController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

protocol WriteReviewDelegate: AnyObject {
    func dismiss()
    func didSuccessUpload()
}

extension EmptyPresentViewController: WriteReviewDelegate {
    func dismiss() {
        guard let tabBarController else { return }
        tabBarController.selectedIndex = tabBarController.previousSelectedIndex
    }
    
    func didSuccessUpload() {
        tabBarController?.selectedIndex = 1
    }
}
