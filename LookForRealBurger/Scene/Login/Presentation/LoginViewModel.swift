//
//  LoginViewModel.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/21/24.
//

import Foundation

import RxCocoa
import RxSwift

protocol LoginInput {
    func didEditEmailText(text: String)
    func didEditPasswordText(text: String)
    func didLoginTap(query: LoginQuery)
    func didJoinTap()
    func saveToken(loginUser: LoginUser)
}

protocol LoginOutput {
    var trimmedEmailText: PublishRelay<String> { get }
    var trimmedPasswordText: PublishRelay<String> { get }
    var toastMessage: PublishRelay<String> { get }
    var goToMain: PublishRelay<Void> { get }
    var goToJoin: PublishRelay<Void> { get }
}

typealias LoginViewModel = LoginInput & LoginOutput

final class DefaultLoginViewModel: LoginOutput {
    private let loginUseCase: LoginUseCase
    private let accessStorage: AccessStorage
    private let disposeBag: DisposeBag
    
    var trimmedEmailText = PublishRelay<String>()
    var trimmedPasswordText = PublishRelay<String>()
    var toastMessage = PublishRelay<String>()
    var goToMain = PublishRelay<Void>()
    var goToJoin = PublishRelay<Void>()
    
    init(
        loginUseCase: LoginUseCase,
        accessStorage: AccessStorage,
        disposeBag: DisposeBag = DisposeBag()
    ) {
        self.loginUseCase = loginUseCase
        self.accessStorage = accessStorage
        self.disposeBag = disposeBag
    }
}

extension DefaultLoginViewModel: LoginInput {
    func didEditEmailText(text: String) {
        let trimmedText = text.filter { $0 != " " }
        trimmedEmailText.accept(trimmedText)
    }
    
    func didEditPasswordText(text: String) {
        let trimmedText = text.filter { $0 != " " }
        trimmedPasswordText.accept(trimmedText)
    }
    
    func didLoginTap(query: LoginQuery) {
        loginUseCase.loginExecute(query: query)
            .asDriver(onErrorJustReturn: .failure(.unknown(R.Phrase.errorOccurred)))
            .drive(with: self) { owner, result in
                switch result {
                case .success(let value):
                    print("login success", value)
                    owner.saveToken(loginUser: value)
                    owner.goToMain.accept(())
                case .failure(let error):
                    switch error {
                    case .network(let message):
                        owner.toastMessage.accept(message)
                    case .missingFields(let message):
                        owner.toastMessage.accept(message)
                    case .accountVerify(let message):
                        owner.toastMessage.accept(message)
                    case .unknown(let message):
                        owner.toastMessage.accept(message)
                    case .existBlank:
                        break
                    case .existUser:
                        break
                    case .enable:
                        break
                    case .invalidToken:
                        break
                    case .forbidden:
                        break
                    case .expiredRefreshToken:
                        break
                    case .expiredAccessToken:
                        break
                    }
                }
            } onCompleted: { _ in
                print("loginExecute completed")
            } onDisposed: { _ in
                print("loginExecute disposed")
            }
            .disposed(by: disposeBag)
    }
    
    func didJoinTap() {
        goToJoin.accept(())
    }
    
    func saveToken(loginUser: LoginUser) {
        accessStorage.accessToken = loginUser.accessToken
        accessStorage.refreshToken = loginUser.refreshToken
    }
}
