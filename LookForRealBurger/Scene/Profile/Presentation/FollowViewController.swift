//
//  FollowViewController.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/2/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Tabman

final class FollowViewController: BaseViewController {
    private var followListTabView: FollowListTabViewController!
    private var disposeBag: DisposeBag!
    
    private weak var coordinator: ReviewProfileNavigation!
    
    static func create(
        followListTabView: FollowListTabViewController,
        disposeBag: DisposeBag = DisposeBag()
    ) -> FollowViewController {
        let view = FollowViewController()
        view.followListTabView = followListTabView
        view.disposeBag = disposeBag
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackButton()
        addChild(followListTabView)
        view.addSubview(followListTabView.view)
        followListTabView.view.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.coordinator.goToBack()
            }
            .disposed(by: disposeBag)
    }
}
