//
//  JoinViewController.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/18/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Toast

final class JoinViewController: BaseViewController {
    private let baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let bunUpImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bunUp")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let emailValidImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.preferredSymbolConfiguration = .init(font: UIFont.systemFont(ofSize: 14, weight: .bold))
        imageView.tintColor = R.Color.green
        imageView.isHidden = true
        return imageView
    }()
    
    private let emailSearchBar = BorderRoundedSearchBar(
        borderWidth: 4, borderColor: R.Color.green, placeholder: R.Phrase.emailPlaceholder
    )
    private let emailValidButton = CapsuleButton(
        title: "이메일 중복 검사", backgroudColor: R.Color.red
    )
    private let passwordSearchBar = BorderRoundedSearchBar(
        borderWidth: 4, borderColor: R.Color.yellow, placeholder: R.Phrase.passwordPlaceholder
    )
    private let nickSearchBar = BorderRoundedSearchBar(
        borderWidth: 4, borderColor: R.Color.brown, placeholder: R.Phrase.nickPlaceholder
    )
    private let joinButton = CapsuleButton(
        title: "회원가입", backgroudColor: R.Color.green
    )
    
    private let bunDownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bunDown")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var viewModel: JoinViewModel!
    private var disposeBag: DisposeBag!
    
    static func create(
        with viewModel: JoinViewModel,
        disposeBag: DisposeBag = DisposeBag()
    ) -> JoinViewController {
        let view = JoinViewController()
        view.viewModel = viewModel
        view.disposeBag = disposeBag
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configureHierarchy() {
        view.addSubview(baseView)
        baseView.addSubview(bunUpImageView)
        baseView.addSubview(emailSearchBar)
        baseView.addSubview(emailValidImage)
        baseView.addSubview(emailValidButton)
        baseView.addSubview(passwordSearchBar)
        baseView.addSubview(nickSearchBar)
        baseView.addSubview(joinButton)
        baseView.addSubview(bunDownImageView)
    }
    
    override func configureLayout() {
        baseView.snp.makeConstraints { make in
            make.centerY.equalTo(view.safeAreaLayoutGuide)
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
        
        emailValidImage.snp.makeConstraints { make in
            make.trailing.equalTo(emailSearchBar.snp.trailing).inset(10)
            make.centerY.equalTo(emailSearchBar.snp.centerY)
            make.size.equalTo(20)
        }
        
        emailValidButton.snp.makeConstraints { make in
            make.top.equalTo(emailSearchBar.snp.bottom).offset(12)
            make.height.equalTo(50)
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        passwordSearchBar.snp.makeConstraints { make in
            make.top.equalTo(emailValidButton.snp.bottom).offset(12)
            make.height.equalTo(50)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        nickSearchBar.snp.makeConstraints { make in
            make.top.equalTo(passwordSearchBar.snp.bottom).offset(12)
            make.height.equalTo(50)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        joinButton.snp.makeConstraints { make in
            make.top.equalTo(nickSearchBar.snp.bottom).offset(12)
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
        navigationItem.title = "회원가입"
        setupBackButton()
        emailSearchBar.keyboardType = .emailAddress
        passwordSearchBar.isSecureTextEntry = true
    }
}

extension JoinViewController {
    private func bind() {
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        emailSearchBar.rx.text.orEmpty
            .bind(with: self) { owner, text in
                owner.viewModel.didEditEmailText(text: text)
            }
            .disposed(by: disposeBag)
        
        passwordSearchBar.rx.text.orEmpty
            .bind(with: self) { owner, text in
                owner.viewModel.didEditPasswordText(text: text)
            }
            .disposed(by: disposeBag)
        
        nickSearchBar.rx.text.orEmpty
            .bind(with: self) { owner, text in
                owner.viewModel.didEditNickText(text: text)
            }
            .disposed(by: disposeBag)
        
        emailValidButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(emailSearchBar.rx.text.orEmpty)
            .bind(with: self) { owner, email in
                owner.viewModel.didTapEmailValid(email: email)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            emailSearchBar.rx.text.orEmpty,
            passwordSearchBar.rx.text.orEmpty,
            nickSearchBar.rx.text.orEmpty,
            viewModel.isNotDuplicateEmail
        )
        .bind(with: self) { owner, field in
            print(field)
            if !field.0.isEmpty, !field.1.isEmpty, !field.2.isEmpty, field.3 {
                owner.viewModel.didFilledFieldData(isFilled: true)
            } else {
                owner.viewModel.didFilledFieldData(isFilled: false)
            }
        }
        .disposed(by: disposeBag)
        
        let fieldData = Observable.combineLatest(
            emailSearchBar.rx.text.orEmpty,
            passwordSearchBar.rx.text.orEmpty,
            nickSearchBar.rx.text.orEmpty
        )
        joinButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(fieldData)
            .map { JoinQuery(email: $0.0, password: $0.1, nick: $0.2) }
            .bind(with: self) { owner, query in
                owner.viewModel.didTapJoin(query: query)
            }
            .disposed(by: disposeBag)
        
        viewModel.trimmedEmailText
            .bind(to: emailSearchBar.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.trimmedPasswordText
            .bind(to: passwordSearchBar.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.trimmedNickText
            .bind(to: nickSearchBar.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isValidEmail
            .bind(with: self) { owner, isValid in
                owner.emailValidImage.isHidden = !isValid
                owner.emailValidButton.isEnabled = isValid
            }
            .disposed(by: disposeBag)
        
        viewModel.toastMessage
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, message in
                owner.view.makeToast(message, duration: 1.5, position: .center)
            }
            .disposed(by: disposeBag)
        
        viewModel.isFilledFieldData
            .bind(to: joinButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.isSuccessJoin
            .bind(with: self) { owner, user in
                let vc = JoinScene.makeView(user: user)
                owner.navigationController?.pushViewController(vc, animated: false)
            }
            .disposed(by: disposeBag)
    }
}
