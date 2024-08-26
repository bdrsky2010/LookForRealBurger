//
//  BurgerMapViewController.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/22/24.
//

import UIKit
import CoreLocation

import RxCocoa
import RxSwift
import RxCoreLocation

final class BurgerMapViewController: BaseViewController {
    private var viewModel: BurgerMapViewModel!
    private var disposeBag: DisposeBag!
    
    static func create(
        viewModel: BurgerMapViewModel,
        disposeBag: DisposeBag = DisposeBag()
    ) -> BurgerMapViewController {
        let view = BurgerMapViewController()
        view.viewModel = viewModel
        view.disposeBag = disposeBag
        return view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configureNavigation() {
        navigationItem.title = "버거맵"
    }
    
    override func configureHierarchy() {
        
    }
    
    override func configureLayout() {
        
    }
}

extension BurgerMapViewController {
    private func bind() {
        viewModel.requestAuthAlert
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, message in
                let title = "위치 권한 설정"
                let message = message
                let alert = UIAlertController(title: title,
                                              message: message,
                                              preferredStyle: .alert)
                
                let moveSetting: (UIAlertAction) -> Void = { _ in
                    guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
                    
                    if UIApplication.shared.canOpenURL(settingURL) {
                        UIApplication.shared.open(settingURL)
                    }
                }
                
                // 2. alert button 구성
                let move = UIAlertAction(title: "이동", style: .default, handler: moveSetting)
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                
                // 3. alert에 button 추가
                alert.addAction(move)
                alert.addAction(cancel)
                
                owner.present(alert, animated: true)
            } onCompleted: { _ in
                print("requestAuthAlert onCompleted")
            } onDisposed: { _ in
                print("requestAuthAlert onDisposed")
            }
            .disposed(by: disposeBag)
    }
}
