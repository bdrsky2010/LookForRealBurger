//
//  BurgerHouseReviewDetailUseCase.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/29/24.
//

import Foundation

import RxSwift

protocol BurgerHouseReviewDetailUseCase {
    func getIsLikePostExecute(query: LikeRequestQuery) -> Single<Result<GetIsLikePost, LikeError>>
    func getIsBookmarkPostExecute(query: BookmarkRequestQuery) -> Single<Result<GetIsBookmarkPost, LikeError>>
    func getSingleBurgerHouseExecute(
        query: GetSingleBurgerHouseQuery
    ) -> Single<Result<GetBurgerHouse, PostError>>
    func judgeTheReviewCreator(creator: Creator, myUserId: String) -> ProfileType
    func refreshAccessTokenExecute() -> Single<Result<AccessToken, AuthError>>
}

final class DefaultBurgerHouseReviewDetailUseCase {
    private let postRepository: PostRepository
    private let authRepository: AuthRepository
    private let likeRepository: LikeRepository
    
    init(
        postRepository: PostRepository,
        authRepository: AuthRepository,
        likeRepository: LikeRepository
    ) {
        self.postRepository = postRepository
        self.authRepository = authRepository
        self.likeRepository = likeRepository
    }
}

extension DefaultBurgerHouseReviewDetailUseCase: BurgerHouseReviewDetailUseCase {
    func getIsLikePostExecute(
        query: LikeRequestQuery
    ) -> Single<Result<GetIsLikePost, LikeError>> {
        return Single.create { [weak self] single -> Disposable in
            guard let self else {
                single(.success(.failure(.unknown(message: R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            likeRepository.likeRequest(query: query) { result in
                switch result {
                case .success(let success):
                    single(.success(.success(success)))
                case .failure(let failure):
                    single(.success(.failure(failure)))
                }
            }
            return Disposables.create()
        }
    }
    
    func getIsBookmarkPostExecute(
        query: BookmarkRequestQuery
    ) -> Single<Result<GetIsBookmarkPost, LikeError>> {
        return Single.create { [weak self] single -> Disposable in
            guard let self else {
                single(.success(.failure(.unknown(message: R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            likeRepository.bookmarkRequest(query: query) { result in
                switch result {
                case .success(let success):
                    single(.success(.success(success)))
                case .failure(let failure):
                    single(.success(.failure(failure)))
                }
            }
            return Disposables.create()
        }
    }
    
    func getSingleBurgerHouseExecute(
        query: GetSingleBurgerHouseQuery
    ) -> Single<Result<GetBurgerHouse, PostError>> {
        return Single.create { [weak self] single -> Disposable in
            guard let self else {
                single(.success(.failure(.unknown(R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            postRepository.getSingleBurgerHouseRequest(
                query: query
            ) { result in
                switch result {
                case .success(let success):
                    single(.success(.success(success)))
                case .failure(let failure):
                    single(.success(.failure(failure)))
                }
            }
            return Disposables.create()
        }
    }
    
    func judgeTheReviewCreator(creator: Creator, myUserId: String) -> ProfileType {
        if creator.userId == myUserId {
            return .me(myUserId)
        }
        return .other(creator.userId, myUserId)
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

extension BurgerHouseReviewDetailUseCase {
    func setSuccessFetch(_ flag: Bool) { }
}

final class MockBurgerHouseReviewDetailUseCase: BurgerHouseReviewDetailUseCase {
    var isSuccessFetch = false
    
    func getIsLikePostExecute(query: LikeRequestQuery) -> Single<Result<GetIsLikePost, LikeError>> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.success(.failure(.unknown(message: ""))))
                return Disposables.create()
            }
            
            if isSuccessFetch {
                single(.success(.success(GetIsLikePost(isLike: query.likeStatus))))
            } else {
                single(.success(.failure(.unknown(message: ""))))
            }
            
            return Disposables.create()
        }
    }
    func getIsBookmarkPostExecute(query: BookmarkRequestQuery) -> Single<Result<GetIsBookmarkPost, LikeError>> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.success(.failure(.unknown(message: ""))))
                return Disposables.create()
            }
            
            if isSuccessFetch {
                single(.success(.success(GetIsBookmarkPost(isBookmark: query.bookmarkStatus))))
            } else {
                single(.success(.failure(.unknown(message: ""))))
            }
            
            return Disposables.create()
        }
    }
    func getSingleBurgerHouseExecute(
        query: GetSingleBurgerHouseQuery
    ) -> Single<Result<GetBurgerHouse, PostError>> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.success(.failure(.unknown(""))))
                return Disposables.create()
            }
            
            if isSuccessFetch {
                single(.success(.success(GetBurgerHouse.dummy)))
            } else {
                single(.success(.failure(.unknown(""))))
            }
            
            return Disposables.create()
        }
    }
    
    func judgeTheReviewCreator(creator: Creator, myUserId: String) -> ProfileType {
        if creator.userId == myUserId {
            return .me(myUserId)
        }
        return .other(creator.userId, myUserId)
    }
    
    func refreshAccessTokenExecute() -> Single<Result<AccessToken, AuthError>> {
        return Single.create { single in
            single(.success(.success(AccessToken(accessToken: ""))))
            return Disposables.create()
        }
    }
    
    func setSuccessFetch(_ flag: Bool) { isSuccessFetch = flag }
}
