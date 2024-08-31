//
//  BurgerHouseReviewDetailUseCase.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/29/24.
//

import Foundation

import RxSwift

protocol BurgerHouseReviewDetailUseCase {
    
    func refreshAccessTokenExecute() -> Single<Result<AccessToken, AuthError>>
}

final class DefaultBurgerHouseReviewDetailUseCase {
    private let postRepository: PostRepository
    private let authRepository: AuthRepository
    
    init(
        postRepository: PostRepository,
        authRepository: AuthRepository
    ) {
        self.postRepository = postRepository
        self.authRepository = authRepository
    }
}

extension DefaultBurgerHouseReviewDetailUseCase: BurgerHouseReviewDetailUseCase {
    
    
    func refreshAccessTokenExecute() -> Single<Result<AccessToken, AuthError>> {
        return Single.create { [weak self] single -> Disposable in
            guard let self else {
                single(.success(.failure(.unknown(R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            authRepository.refreshAccessToken { result in
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

