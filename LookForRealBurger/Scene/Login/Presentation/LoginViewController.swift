//
//  LoginViewController.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/21/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Toast

final class LoginViewController: BaseViewController {
    private let appTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIWindowScene.isSmallDevice ? R.Font.chab35 : R.Font.chab50
        label.numberOfLines = 0
        label.textColor = R.Color.brown
        label.textAlignment = .center
        label.text = "Look For\nReal Burger"
        return label
    }()
    
    private let baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    private let bunUpImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bunUp")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let emailSearchBar = BorderRoundedSearchBar(
        borderWidth: 4, borderColor: R.Color.red, placeholder: R.Phrase.emailPlaceholder
    )

    private let passwordSearchBar = BorderRoundedSearchBar(
        borderWidth: 4, borderColor: R.Color.yellow, placeholder: R.Phrase.passwordPlaceholder
    )
    
    private let loginButton = CapsuleButton(
        title: R.Phrase.login, backgroudColor: R.Color.green
    )
    
    private let joinButton = CapsuleButton(
        title: R.Phrase.joinTitle, backgroudColor: R.Color.brown
    )
    
    private let bunDownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bunDown")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var viewModel: LoginViewModel!
    private var disposeBag: DisposeBag!
    
    weak var coordinator: LoginNavigation!
    
    static func create(
        with viewModel: LoginViewModel,
        disposeBag: DisposeBag = DisposeBag()
    ) -> LoginViewController {
        let view = LoginViewController()
        view.viewModel = viewModel
        view.disposeBag = disposeBag
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configureHierarchy() {
        view.addSubview(appTitleLabel)
        view.addSubview(baseView)
        baseView.addSubview(bunUpImageView)
        baseView.addSubview(emailSearchBar)
        baseView.addSubview(passwordSearchBar)
        baseView.addSubview(loginButton)
        baseView.addSubview(joinButton)
        baseView.addSubview(bunDownImageView)
    }
    
    override func configureLayout() {
        appTitleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(baseView.snp.top).offset(-12)
        }
        
        baseView.snp.makeConstraints { make in
            make.centerY.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        bunUpImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(105)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
  
        emailSearchBar.snp.makeConstraints { make in
            make.top.equalTo(bunUpImageView.snp.bottom).offset(12)
            make.height.equalTo(50)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        passwordSearchBar.snp.makeConstraints { make in
            make.top.equalTo(emailSearchBar.snp.bottom).offset(12)
            make.height.equalTo(50)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordSearchBar.snp.bottom).offset(12)
            make.height.equalTo(50)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        joinButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(12)
            make.height.equalTo(50)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        bunDownImageView.snp.makeConstraints { make in
            make.top.equalTo(joinButton.snp.bottom).offset(12)
            make.height.equalTo(60)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func configureUI() {
        emailSearchBar.keyboardType = .emailAddress
        passwordSearchBar.isSecureTextEntry = true
    }
}

extension LoginViewController {
    private func bind() {
        /*
         "timmy@timmy.com"
         "timmy"
         
         "timmy2@timmy.com"
         "timmy"
         */
        Observable.just("timmy@timmy.co.kr")
            .bind(to: emailSearchBar.rx.text)
            .disposed(by: disposeBag)
        
        Observable.just("timmy")
            .bind(to: passwordSearchBar.rx.text)
            .disposed(by: disposeBag)
        
        emailSearchBar.rx.text.orEmpty
            .bind(with: self) { owner, email in
                owner.viewModel.didEditEmailText(text: email)
            }
            .disposed(by: disposeBag)
        
        passwordSearchBar.rx.text.orEmpty
            .bind(with: self) { owner, password in
                owner.viewModel.didEditPasswordText(text: password)
            }
            .disposed(by: disposeBag)
        
        let fieldData = Observable.combineLatest(
            emailSearchBar.rx.text.orEmpty,
            passwordSearchBar.rx.text.orEmpty
        )
        
        loginButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(fieldData)
            .bind(with: self) { owner, fieldData in
                owner.viewModel.didLoginTap(
                    query: .init(email: fieldData.0, password: fieldData.1)
                )
            }
            .disposed(by: disposeBag)
        
        joinButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.didJoinTap()
            }
            .disposed(by: disposeBag)
        
        viewModel.trimmedEmailText
            .bind(to: emailSearchBar.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.trimmedPasswordText
            .bind(to: passwordSearchBar.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.toastMessage
            .bind(with: self) { owner, message in
                owner.view.makeToast(message, duration: 1.5, position: .center)
            }
            .disposed(by: disposeBag)
        
        viewModel.goToMain
            .bind(with: self) { owner, _ in
                owner.coordinator.goToMainTabbar()
            }
            .disposed(by: disposeBag)
        
        viewModel.goToJoin
            .bind(with: self) { owner, _ in
                owner.coordinator.goToJoin()
            }
            .disposed(by: disposeBag)
    }
}
