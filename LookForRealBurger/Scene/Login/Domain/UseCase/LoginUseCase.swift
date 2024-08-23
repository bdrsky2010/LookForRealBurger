//
//  LoginUseCase.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/22/24.
//

import Foundation

import RxSwift

protocol LoginUseCase {
    func loginExecute(query: LoginQuery) -> Single<Result<LoginUser, LoginError>>
}

final class DefaultLoginUseCase {
    private let loginRepository: LoginRepository
    
    init(loginRepository: LoginRepository) {
        self.loginRepository = loginRepository
    }
}

extension DefaultLoginUseCase: LoginUseCase {
    func loginExecute(query: LoginQuery) -> Single<Result<LoginUser, LoginError>> {
        Single.create { [weak self] single in
            guard let self else {
                single(.success(.failure(.unknown(R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            loginRepository.loginRequest(query: query) { result in
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
