//
//  MoreViewController.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/1/24.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift
import SnapKit

final class MoreViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    
    private let logoutButton = CapsuleButton(title: "로그아웃", font: R.Font.chab20, backgroudColor: R.Color.red)
    private let withdrawButton = CapsuleButton(title: "회원탈퇴", font: R.Font.chab20, backgroudColor: R.Color.green)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configureNavigation() {
        setupBackButton()
    }
    
    override func configureHierarchy() {
        view.addSubview(logoutButton)
        view.addSubview(withdrawButton)
    }
    
    override func configureLayout() {
        logoutButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.centerY).offset(-50)
            make.size.equalTo(100)
        }
        
        withdrawButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.centerY).offset(50)
            make.size.equalTo(100)
        }
    }
}

extension MoreViewController {
    private func bind() {
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        logoutButton.rx
            .panGesture()
            .when(.changed)
            .asLocation(in: .superview)
            .bind(with: self) { owner, point in
                owner.updateButtonPosition(button: owner.logoutButton, point: point)
            }
            .disposed(by: disposeBag)
        
        logoutButton.rx.tap
            .bind(with: self) { owner, _ in
                let alert = UIAlertController(title: "로그아웃 하시겠습니까?", message: "", preferredStyle: .alert)
                let check = UIAlertAction(title: "확인", style: .default) { _ in
                    let view = LoginScene.makeView()
                    let nav = UINavigationController()
                    nav.pushViewController(view, animated: false)
                    owner.changeRootViewController(nav)
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                alert.addAction(check)
                alert.addAction(cancel)
                owner.present(alert, animated: true)
            }
            .disposed(by: disposeBag)
        
        withdrawButton.rx
            .panGesture()
            .when(.changed)
            .asLocation(in: .superview)
            .bind(with: self) { owner, point in
                owner.updateButtonPosition(button: owner.withdrawButton, point: point)
            }
            .disposed(by: disposeBag)
    }
    
    private func updateButtonPosition(button: UIButton, point: CGPoint) {
        UIView.animate(withDuration: 0.1) {
            button.snp.remakeConstraints { make in
                make.center.equalTo(point)
                make.width.height.equalTo(100)
            }
            self.view.layoutIfNeeded()
        }
    }
}
