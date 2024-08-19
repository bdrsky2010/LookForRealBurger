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
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() { }
    
    func configureLayout() { }
}
