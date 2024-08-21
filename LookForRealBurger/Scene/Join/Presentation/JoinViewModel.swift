//
//  JoinViewModel.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/18/24.
//

import Foundation

import RxCocoa
import RxSwift

protocol JoinInput {
    func didEditEmailText(text: String)
    func didEditPasswordText(text: String)
    func didEditNickText(text: String)
    func didFilledFieldData(isFilled: Bool)
    func didTapEmailValid(email: String)
    func didTapJoin(query: JoinQuery)
}

protocol JoinOutput {
    var trimmedEmailText: PublishRelay<String> { get }
    var trimmedPasswordText: PublishRelay<String> { get }
    var trimmedNickText: PublishRelay<String> { get }
    var toastMessage: PublishRelay<String> { get }
    var isValidEmail: BehaviorRelay<Bool> { get }
    var isNotDuplicateEmail: BehaviorRelay<Bool> { get }
    var isFilledFieldData: BehaviorRelay<Bool> { get }
    var isSuccessJoin: PublishRelay<JoinUser> { get }
}

typealias JoinViewModel = JoinInput & JoinOutput

final class DefaultLFRBJoinViewModel: JoinOutput {
    private let joinUseCase: JoinUseCase
    private let disposeBag: DisposeBag
    
    private var originEmail = ""
    
    var trimmedEmailText = PublishRelay<String>()
    var trimmedPasswordText = PublishRelay<String>()
    var trimmedNickText = PublishRelay<String>()
    var toastMessage = PublishRelay<String>()
    var isValidEmail = BehaviorRelay<Bool>(value: false)
    var isNotDuplicateEmail = BehaviorRelay<Bool>(value: false)
    var isFilledFieldData = BehaviorRelay<Bool>(value: false)
    var isSuccessJoin = PublishRelay<JoinUser>()
    
    init(
        joinUseCase: JoinUseCase,
        disposeBag: DisposeBag = DisposeBag()
    ) {
        self.joinUseCase = joinUseCase
        self.disposeBag = disposeBag
    }
}

extension DefaultLFRBJoinViewModel: JoinInput {
    func didEditEmailText(text: String) {
        let trimmedText = text.filter { $0 != " " }
        trimmedEmailText.accept(trimmedText)
        isValidEmail.accept(joinUseCase.isValidEmail(trimmedText))
        if trimmedText != originEmail {
            isNotDuplicateEmail.accept(false)
            originEmail = trimmedText
        }
    }
    
    func didEditPasswordText(text: String) {
        let trimmedText = text.filter { $0 != " " }
        trimmedPasswordText.accept(trimmedText)
    }
    
    func didEditNickText(text: String) {
        let trimmedText = text.filter { $0 != " " }
        trimmedNickText.accept(trimmedText)
    }
    
    func didFilledFieldData(isFilled: Bool) {
        isFilledFieldData.accept(isFilled)
    }
    
    func didTapEmailValid(email: String) {
        joinUseCase.checkValidEmail(email: email)
            .asDriver(onErrorJustReturn: .failure(.unknown(R.Phrase.errorOccurred)))
            .drive(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.toastMessage.accept(value.message)
                    owner.isNotDuplicateEmail.accept(true)
                case .failure(let error):
                    owner.isNotDuplicateEmail.accept(false)
                    let errorMessage: String
                    switch error {
                    case .network(let message):
                        errorMessage = message
                    case .missingFields(let message):
                        errorMessage = message
                    case .enable(let message):
                        errorMessage = message
                    case .unknown(let message):
                        errorMessage = message
                    }
                    owner.toastMessage.accept(errorMessage)
                }
            } onCompleted: { _ in
                print("checkValidEmail completed")
            } onDisposed: { _ in
                print("checkValidEmail diposed")
            }
            .disposed(by: disposeBag)

    }
    
    func didTapJoin(query: JoinQuery) {
        joinUseCase.joinMembership(query: query)
            .asDriver(onErrorJustReturn: .failure(.unknown(R.Phrase.errorOccurred)))
            .drive(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.isSuccessJoin.accept(value)
                case .failure(let error):
                    let errorMessage: String
                    switch error {
                    case .network(let message):
                        errorMessage = message
                    case .missingFields(let message):
                        errorMessage = message
                    case .existBlank(let message):
                        errorMessage = message
                    case .existUser(let message):
                        errorMessage = message
                    case .unknown(let message):
                        errorMessage = message
                    }
                    owner.toastMessage.accept(errorMessage)
                }
            } onCompleted: { _ in
                print("joinMembership completed")
            } onDisposed: { _ in
                print("joinMembership diposed")
            }
            .disposed(by: disposeBag)
    }
}
