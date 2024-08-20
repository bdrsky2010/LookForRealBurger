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
    func checkValidEmail(email: String) -> Single<Result<EmailValidMessage, EmailValidError>>
    func joinMembership(query: JoinQuery) -> Single<Result<JoinUser, JoinError>>
}

final class DefaultJoinUseCase {
    private let joinRepository: JoinRepository
    private let emailValidRepository: EmailValidRepository
    
    init(
        joinRepository: JoinRepository,
        emailValidRepository: EmailValidRepository
    ) {
        self.joinRepository = joinRepository
        self.emailValidRepository = emailValidRepository
    }
}

extension DefaultJoinUseCase: JoinUseCase {
    func isValidEmail(_ email: String) -> Bool {
       let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
       let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
       return emailTest.evaluate(with: email)
    }
    
    func checkValidEmail(email: String) -> Single<Result<EmailValidMessage, EmailValidError>> {
        return Single.create { [weak self] single -> Disposable in
            guard let self else {
                single(.success(.failure(.unknown(R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            emailValidRepository.emailValidRequest(query: .init(email: email)) { result in
                switch result {
                case .success(let value):
                    print("성공")
                    single(.success(.success(value)))
                case .failure(let error):
                    print("에러")
                    single(.success(.failure(error)))
                }
            }
            return Disposables.create()
        }
    }
    
    func joinMembership(query: JoinQuery) -> Single<Result<JoinUser, JoinError>> {
        return Single.create { [weak self] single -> Disposable in
            guard let self else {
                single(.success(.failure(.unknown(R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            joinRepository.joinRequest(query: query) { result in
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
