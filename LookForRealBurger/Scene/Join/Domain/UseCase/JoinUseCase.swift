//
//  JoinUseCase.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/19/24.
//

import Foundation
import RxSwift

protocol JoinUseCase {
    func isValidEmail(_ email: String) -> Bool
    func checkValidEmail(email: String) -> Single<Result<EmailValidMessage, AuthError>>
    func joinMembership(query: JoinQuery) -> Single<Result<JoinUser, AuthError>>
}

final class DefaultJoinUseCase {
    private let authRepository: AuthRepository
    
    init(
        authRepository: AuthRepository
    ) {
        self.authRepository = authRepository
    }
}

extension DefaultJoinUseCase: JoinUseCase {
    func isValidEmail(_ email: String) -> Bool {
       let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
       let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
       return emailTest.evaluate(with: email)
    }
    
    func checkValidEmail(email: String) -> Single<Result<EmailValidMessage, AuthError>> {
        return Single.create { [weak self] single -> Disposable in
            guard let self else {
                single(.success(.failure(.unknown(R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            authRepository.emailValidRequest(query: .init(email: email)) { result in
                switch result {
                case .success(let value):
                    single(.success(.success(value)))
                case .failure(let error):
                    single(.success(.failure(error)))
                }
            }
            return Disposables.create()
        }
    }
    
    func joinMembership(query: JoinQuery) -> Single<Result<JoinUser, AuthError>> {
        return Single.create { [weak self] single -> Disposable in
            guard let self else {
                single(.success(.failure(.unknown(R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            authRepository.joinRequest(query: query) { result in
                switch result {
                case .success(let value):
                    single(.success(.success(value)))
                case .failure(let error):
                    single(.success(.failure(error)))
                }
            }
            return Disposables.create()
        }
    }
}

final class MockJoinUsecase: JoinUseCase {
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func checkValidEmail(email: String) -> Single<Result<EmailValidMessage, AuthError>> {
        Single.create { single in
            if email == "notDuplicate" {
                single(.success(.success(EmailValidMessage(message: ""))))
            } else if email == "duplicate" {
                single(.success(.failure(.unknown(""))))
            }
            return Disposables.create()
        }
    }
    
    func joinMembership(query: JoinQuery) -> Single<Result<JoinUser, AuthError>> {
        Single.create { single in
            if query.email == "pass" {
                single(.success(.success(JoinUser(nick: ""))))
            } else if query.email == "error" {
                single(.success(.failure(.unknown(""))))
            }
            return Disposables.create()
        }
    }
}
