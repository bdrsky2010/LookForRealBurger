//
//  BaseViewController.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/18/24.
//

import UIKit

class BaseViewController: UIViewController {
    deinit {
        print("deinit -> \(String(describing: self))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = R.Color.background
        configureNavigation()
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    func configureNavigation() { }
    func configureHierarchy() { }
    func configureLayout() { }
    func configureUI() { }
}

extension BaseViewController {
    func goToLogin() {
        let alert = UIAlertController(
            title: R.Phrase.expiredLogin,
            message: R.Phrase.expiredLoginExplain,
            preferredStyle: .alert
        )
        let check = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self else { return }
            let view = LoginScene.makeView()
            let navigationContoller = UINavigationController()
            navigationContoller.pushViewController(view, animated: false)
            if self is WriteReviewViewController {
                dismiss(animated: false)
            }
            changeRootViewController(navigationContoller)
        }
        alert.addAction(check)
        present(alert, animated: true)
    }
}
