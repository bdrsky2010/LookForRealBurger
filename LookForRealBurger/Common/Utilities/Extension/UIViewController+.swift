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
