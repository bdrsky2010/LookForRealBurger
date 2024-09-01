//
//  BurgerHouseReviewDetailUseCase.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/29/24.
//

import Foundation

import RxSwift

protocol BurgerHouseReviewDetailUseCase {
    func getMyUserIdExecute() -> Single<Result<GetMyUserId, ProfileError>>
    func getIsLikePostExecute(query: LikeRequestQuery) -> Single<Result<GetIsLikePost, LikeError>>
    func getIsBookmarkPostExecute(query: BookmarkRequestQuery) -> Single<Result<GetIsBookmarkPost, LikeError>>
    func refreshAccessTokenExecute() -> Single<Result<AccessToken, AuthError>>
}

final class DefaultBurgerHouseReviewDetailUseCase {
    private let postRepository: PostRepository
    private let authRepository: AuthRepository
    private let profileRepository: ProfileRepository
    private let likeRepository: LikeRepository
    
    init(
        postRepository: PostRepository,
        authRepository: AuthRepository,
        profileRepository: ProfileRepository,
        likeRepository: LikeRepository
    ) {
        self.postRepository = postRepository
        self.authRepository = authRepository
        self.profileRepository = profileRepository
        self.likeRepository = likeRepository
    }
}

extension DefaultBurgerHouseReviewDetailUseCase: BurgerHouseReviewDetailUseCase {
    func getMyUserIdExecute() -> Single<Result<GetMyUserId, ProfileError>> {
        return Single.create { [weak self] single -> Disposable in
            guard let self else {
                single(.success(.failure(.unknown(R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            profileRepository.myUserIdRequest { result in
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

