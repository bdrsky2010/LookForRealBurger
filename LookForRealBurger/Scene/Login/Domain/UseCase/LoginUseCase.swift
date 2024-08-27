//
//  LoginUseCase.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/22/24.
//

import Foundation

import RxSwift

protocol LoginUseCase {
    func loginExecute(query: LoginQuery) -> Single<Result<LoginUser, AuthError>>
}

final class DefaultLoginUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
}

extension DefaultLoginUseCase: LoginUseCase {
    func loginExecute(query: LoginQuery) -> Single<Result<LoginUser, AuthError>> {
        Single.create { [weak self] single in
            guard let self else {
                single(.success(.failure(.unknown(message: R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            authRepository.loginRequest(query: query) { result in
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
