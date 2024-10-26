//
//  LocalSearchUseCase.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/25/24.
//

import Foundation

import RxSwift

protocol LocalSearchUseCase {
    func localSearchExecute(
        query: LocalSearchQuery
    ) -> Single<Result<BurgerPage, KakaoAPIError>>
    
    func existBurgerHouseExecute(
        query: GetPostQuery,
        localId: String
    ) -> Single<Result<ExistBurgerHouseData, PostError>>
    
    func uploadBurgerHouseExecute(
        query: UploadBurgerHouseQuery
    ) -> Single<Result<GetBurgerHouse, PostError>>
    
    func refreshAccessTokenExecute() -> Single<Result<AccessToken, AuthError>>
}

final class DefaultLocalSearchUseCase {
    private let localSearchRepository: LocalSearchRepository
    private let postRepository: PostRepository
    private let authRepository: AuthRepository
    
    init(
        localSearchRepository: LocalSearchRepository,
        postRepository: PostRepository,
        authRepository: AuthRepository
    ) {
        self.localSearchRepository = localSearchRepository
        self.postRepository = postRepository
        self.authRepository = authRepository
    }
}

extension DefaultLocalSearchUseCase: LocalSearchUseCase {
    func localSearchExecute(
        query: LocalSearchQuery
    ) -> Single<Result<BurgerPage, KakaoAPIError>> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.success(.failure(.unknown(message: R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            localSearchRepository.request(query: query) { result in
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
    
    func existBurgerHouseExecute(
        query: GetPostQuery,
        localId: String
    ) -> Single<Result<ExistBurgerHouseData, PostError>> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.success(.failure(.unknown(R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            postRepository.getBurgerHouseRequest(query: query) { result in
                switch result {
                case .success(let value):
                    let filteredList = value.filter { $0.localId == localId }
                    print(value, filteredList)
                    let burgerHousePostId = filteredList.first?.burgerHousePostId
                    let isExist = !filteredList.isEmpty
                    single(.success(.success(.init(burgerHousePostId: burgerHousePostId, isExist: isExist))))
                case .failure(let error):
                    single(.success(.failure(error)))
                }
            }
            return Disposables.create()
        }
    }
    
    func uploadBurgerHouseExecute(
        query: UploadBurgerHouseQuery
    ) -> Single<Result<GetBurgerHouse, PostError>> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.success(.failure(.unknown(R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            postRepository.uploadBurgerHouse(query: query) { result in
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

extension LocalSearchUseCase {
    func setSuccessExecute(_ flag: Bool) { }
}

final class MockLocalSearchUseCase: LocalSearchUseCase {
    private var isSuccessExecute = false
    
    func localSearchExecute(query: LocalSearchQuery) -> Single<Result<BurgerPage, KakaoAPIError>> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.success(.failure(.unknown(message: ""))))
                return Disposables.create()
            }
            
            if isSuccessExecute {
                single(.success(.success(BurgerPage(nextPage: 0, isEndPage: true, burgerHouses: []))))
            } else {
                single(.success(.failure(.unknown(message: ""))))
            }
            
            return Disposables.create()
        }
    }
    
    func existBurgerHouseExecute(query: GetPostQuery, localId: String) -> Single<Result<ExistBurgerHouseData, PostError>> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.success(.failure(.unknown(""))))
                return Disposables.create()
            }
            
            if isSuccessExecute {
                if localId == "exist" {
                    single(.success(.success(ExistBurgerHouseData(burgerHousePostId: "exist", isExist: true))))
                } else {
                    single(.success(.success(ExistBurgerHouseData(burgerHousePostId: "notExist", isExist: false))))
                }
            } else {
                single(.success(.failure(.unknown(""))))
            }
            
            return Disposables.create()
        }
    }
    
    func uploadBurgerHouseExecute(query: UploadBurgerHouseQuery) -> Single<Result<GetBurgerHouse, PostError>> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.success(.failure(.unknown(""))))
                return Disposables.create()
            }
            
            if isSuccessExecute {
                single(.success(.success(GetBurgerHouse.dummy)))
            } else {
                single(.success(.failure(.unknown(""))))
            }
            
            return Disposables.create()
        }
    }
    
    func refreshAccessTokenExecute() -> Single<Result<AccessToken, AuthError>> {
        return Single.create { single in
            single(.success(.success(AccessToken(accessToken: ""))))
            return Disposables.create()
        }
    }
    
    func setSuccessExecute(_ flag: Bool) { isSuccessExecute = flag }
}
