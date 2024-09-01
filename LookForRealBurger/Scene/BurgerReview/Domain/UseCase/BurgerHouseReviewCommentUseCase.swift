//
//  BurgerHouseReviewCommentUseCase.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/1/24.
//

import Foundation

import RxSwift

protocol BurgerHouseReviewCommentUseCase {
    func writeCommentExecute(
        query: WriteCommentQuery
    ) -> Single<Result<Comment, CommentError>>
    
    func refreshAccessTokenExecute() -> Single<Result<AccessToken, AuthError>>
}

final class DefaultBurgerHouseReviewCommentUseCase {
    private let commentRepository: CommentRepository
    private let authRepository: AuthRepository
    
    init(
        commentRepository: CommentRepository,
        authRepository: AuthRepository
    ) {
        self.commentRepository = commentRepository
        self.authRepository = authRepository
    }
}

extension DefaultBurgerHouseReviewCommentUseCase: BurgerHouseReviewCommentUseCase {
    func writeCommentExecute(
        query: WriteCommentQuery
    ) -> Single<Result<Comment, CommentError>> {
        Single.create { [weak self] single -> Disposable in
            guard let self else {
                single(.success(.failure(.unknown(message: R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            commentRepository.writeCommentRequest(
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
