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

final class LoginViewController: BaseViewController {
    private let appTitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.Font.chab30
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
        borderWidth: 4, borderColor: R.Color.red, placeholder: "아이디(이메일)"
    )

    private let passwordSearchBar = BorderRoundedSearchBar(
        borderWidth: 4, borderColor: R.Color.yellow, placeholder: "비밀번호"
    )
    
    private let loginButton = CapsuleButton(
        title: "로그인", backgroudColor: R.Color.green
    )
    
    private let joinButton = CapsuleButton(
        title: "회원가입", backgroudColor: R.Color.brown
    )
    
    private let bunDownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bunDown")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var viewModel: LoginViewModel!
    
    static func create(with viewModel: LoginViewModel) -> LoginViewController {
        let view = LoginViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func configureNavigation() {
        
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
        
    }
}
