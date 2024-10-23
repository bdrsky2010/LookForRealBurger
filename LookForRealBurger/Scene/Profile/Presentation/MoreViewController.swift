//
//  MoreViewController.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/1/24.
//

import UIKit

import iamport_ios
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Toast

final class MoreViewController: BaseViewController {
    private let logoutButton = CapsuleButton(title: R.Phrase.logout, font: R.Font.chab20, backgroudColor: R.Color.red)
    private let withdrawButton = CapsuleButton(title: R.Phrase.withdraw, font: R.Font.chab20, backgroudColor: R.Color.green)
    private let supportButton = CapsuleButton(title: R.Phrase.support, font: R.Font.chab20, backgroudColor: R.Color.orange)
    private let disposeBag = DisposeBag()
    
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
        view.addSubview(supportButton)
    }
    
    override func configureLayout() {
        logoutButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.centerY).offset(-70)
            make.size.equalTo(100)
        }
        
        withdrawButton.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(100)
        }
        
        supportButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.centerY).offset(70)
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
                let alert = UIAlertController(title: R.Phrase.logoutComment, message: "", preferredStyle: .alert)
                let check = UIAlertAction(title: R.Phrase.check, style: .default) { _ in
                    let view = LoginScene.makeView()
                    let nav = UINavigationController()
                    nav.pushViewController(view, animated: false)
                    owner.changeRootViewController(nav)
                }
                let cancel = UIAlertAction(title: R.Phrase.cancel, style: .cancel)
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
        
        supportButton.rx
            .panGesture()
            .when(.changed)
            .asLocation(in: .superview)
            .bind(with: self) { owner, point in
                owner.updateButtonPosition(button: owner.supportButton, point: point)
            }
            .disposed(by: disposeBag)
        
        supportButton.rx.tap
            .bind(with: self) { owner, _ in
                let payment = IamportPayment(
                    pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
                    merchant_uid: "ios_\(APIKEY.lslp.rawValue)_\(Int(Date().timeIntervalSince1970))",
                    amount: "100").then {
                        $0.pay_method = PayMethod.card.rawValue
                        $0.name = "꺼어어어억~ 맛있다~"
                        $0.buyer_name = "김민재"
                        $0.app_scheme = "kmj"
                    }
                
                Iamport.shared.payment(
                    navController: owner.navigationController ?? UINavigationController(),
                    userCode: "imp57573124",
                    payment: payment
                ) { response in
                    if let success = response?.success, success, let impUid = response?.imp_uid {
                        LFRBNetworkManager.shared.request(
                            PaymentRouter.payments(
                                .init(impUid: impUid, postId: "66d6c7cedfc6560142283221")
                            ),
                            of: PaymentResponseDTO.self
                        ) { result in
                            switch result {
                            case .success(_):
                                owner.view.makeToast(R.Phrase.successfulPayment)
                            case .failure(let failure):
                                print(failure)
                                owner.view.makeToast(R.Phrase.errorOccurred)
                            }
                        }
                    } else if let _ = response?.error_msg {
                        owner.view.makeToast(R.Phrase.failedPayment)
                    }
                }
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
