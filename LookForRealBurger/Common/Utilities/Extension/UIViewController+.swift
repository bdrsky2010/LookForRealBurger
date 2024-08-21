//
//  UINavigationController+.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/19/24.
//

import UIKit

extension UIViewController {
    func setupBackButton() {
        let image = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
        let leftBarButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: nil
        )
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
}

extension UIViewController {
    func changeRootViewController(_ rootViewController: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let window = (windowScene.delegate as? SceneDelegate)?.window else { return }

        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
    func changeRootViewController(_ rootViewController: UINavigationController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let window = (windowScene.delegate as? SceneDelegate)?.window else { return }
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
