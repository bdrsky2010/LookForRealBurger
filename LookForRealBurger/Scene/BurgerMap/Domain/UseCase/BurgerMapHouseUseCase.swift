//
//  BurgerMapHouseUseCase.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/29/24.
//

import Foundation

import RxCocoa
import RxSwift

protocol BurgerMapHouseUseCase {
    func fetchSinglePostExecute(
        query: GetSinglePostQuery
    ) -> Single<Result<BurgerHouseReview, PostError>>
    
    func refreshAccessTokenExecute() -> Single<Result<AccessToken, AuthError>>
}

final class DefaultBurgerMapHouseUseCase {
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

extension DefaultBurgerMapHouseUseCase: BurgerMapHouseUseCase {
    func fetchSinglePostExecute(
        query: GetSinglePostQuery
    ) -> Single<Result<BurgerHouseReview, PostError>> {
        return Single.create { [weak self] single -> Disposable in
            guard let self else {
                single(.success(.failure(.unknown(R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            postRepository.getSingleBurgerHouseReviewRequest(query: query) { result in
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
