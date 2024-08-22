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
    private let useCase: LoginUseCase
    private let disposeBag: DisposeBag
    
    var trimmedEmailText = PublishRelay<String>()
    var trimmedPasswordText = PublishRelay<String>()
    var toastMessage = PublishRelay<String>()
    var goToMain = PublishRelay<Void>()
    var goToJoin = PublishRelay<Void>()
    
    init(
        useCase: LoginUseCase,
        disposeBag: DisposeBag = DisposeBag()
    ) {
        self.useCase = useCase
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
        print(query)
        useCase.loginExecute(query: query)
            .asDriver(onErrorJustReturn: .failure(.unknown(R.Phrase.errorOccurred)))
            .drive(with: self) { owner, result in
                switch result {
                case .success(let value):
                    print("login success", value)
                    owner.goToMain.accept(())
                case .failure(let error):
                    let errorMessage: String
                    switch error {
                    case .network(let message):
                        errorMessage = message
                    case .missingFields(let message):
                        errorMessage = message
                    case .accountVerify(let message):
                        errorMessage = message
                    case .unknown(let message):
                        errorMessage = message
                    }
                    owner.toastMessage.accept(errorMessage)
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
}
