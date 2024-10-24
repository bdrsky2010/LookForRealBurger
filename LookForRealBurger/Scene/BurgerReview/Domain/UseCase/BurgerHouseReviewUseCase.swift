//
//  BurgerReviewUseCase.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/29/24.
//

import Foundation

import RxSwift

protocol BurgerHouseReviewUseCase {
    func fetchBurgerReview(query: GetPostQuery) -> Single<Result<GetBurgerHouseReview, PostError>>
    func refreshAccessTokenExecute() -> Single<Result<AccessToken, AuthError>>
}

final class DefaultBurgerHouseReviewUseCase {
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

extension DefaultBurgerHouseReviewUseCase: BurgerHouseReviewUseCase {
    func fetchBurgerReview(
        query: GetPostQuery
    ) -> Single<Result<GetBurgerHouseReview, PostError>> {
        return Single.create { [weak self] single -> Disposable in
            guard let self else {
                single(.success(.failure(.unknown(R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            postRepository.getBurgerHouseReviewRequest(
                query: query
            ) { result in
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

extension BurgerHouseReviewUseCase {
    func setSuccessFetch(_ flag: Bool) { }
    func setSuccessRefresh(_ flag: Bool) { }
}

final class MockBurgerHouseReviewUseCase: BurgerHouseReviewUseCase {
    var isSuccessFetch = false
    var isSuccessRefresh = false
    
    func fetchBurgerReview(query: GetPostQuery) -> Single<Result<GetBurgerHouseReview, PostError>> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.success(.failure(.unknown(R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            
            if isSuccessFetch {
                if query.next == nil {
                    single(.success(.success(GetBurgerHouseReview(reviews: [], nextCursor: "next"))))
                } else if query.next == "next" {
                    single(.success(.success(GetBurgerHouseReview(reviews: [], nextCursor: "0"))))
                } else if query.next == "0" {
                    single(.success(.success(GetBurgerHouseReview(reviews: [], nextCursor: "X"))))
                }
                
            } else {
                single(.success(.failure(.unknown(""))))
            }
            
            return Disposables.create()
        }
    }
    
    func refreshAccessTokenExecute() -> Single<Result<AccessToken, AuthError>> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.success(.failure(.unknown(R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            
            if isSuccessRefresh {
                single(.success(.success(AccessToken(accessToken: ""))))
            } else {
                single(.success(.failure(.unknown(""))))
            }
            
            return Disposables.create()
        }
    }
    
    func setSuccessFetch(_ flag: Bool) { isSuccessFetch = flag }
    func setSuccessRefresh(_ flag: Bool) { isSuccessRefresh = flag }
}
