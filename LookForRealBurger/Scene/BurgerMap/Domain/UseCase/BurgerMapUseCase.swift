//
//  BurgerMapUseCase.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/28/24.
//

import Foundation

import RxCocoa
import RxSwift

protocol BurgerMapUseCase {
    func fetchBurgerHouseExecute(
        query: GetPostQuery
    ) -> Single<Result<[BurgerMapHouse], PostError>>
    
    func refreshAccessTokenExecute() -> Single<Result<AccessToken, AuthError>>
}

final class DefaultBurgerMapUseCase {
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

extension DefaultBurgerMapUseCase: BurgerMapUseCase {
    func fetchBurgerHouseExecute(
        query: GetPostQuery
    ) -> Single<Result<[BurgerMapHouse], PostError>> {
        return Single.create { [weak self] single -> Disposable in
            guard let self else {
                single(.success(.failure(.unknown(R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            postRepository.getBurgerMapHouseRequest(query: query) { result in
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
        return Single.create { [weak self] single in
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

extension BurgerMapUseCase {
    func setSuccessFetch(_ flag: Bool) { }
    func setSuccessRefresh(_ flag: Bool) { }
}

final class MockBurgerMapUseCase: BurgerMapUseCase {
    private var isSuccessFetch = false
    private var isSuccessRefresh = false
    
    func fetchBurgerHouseExecute(query: GetPostQuery) -> Single<Result<[BurgerMapHouse], PostError>> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.success(.failure(.unknown(""))))
                return Disposables.create()
            }
            
            if isSuccessFetch {
                single(.success(.success([])))
            } else {
                single(.success(.failure(.unknown(""))))
            }
            return Disposables.create()
        }
    }
    
    func refreshAccessTokenExecute() -> Single<Result<AccessToken, AuthError>> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.success(.failure(.unknown(""))))
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
