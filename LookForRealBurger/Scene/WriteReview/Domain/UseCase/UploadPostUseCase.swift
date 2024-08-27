//
//  PostUploadUseCase.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/26/24.
//

import Foundation

import RxSwift

protocol UploadPostUseCase {
    func uploadImageExecute(
        files: [Data]
    ) -> Single<Result<UploadedImage, ImageUploadError>>
    
    func uploadReviewExecute(
        query: UploadBurgerHouseReviewQuery
    ) -> Single<Result<BurgerHouseReview, UploadPostError>>
    
    func registerReviewIdExecute(
        query: RegisterReviewIdQuery
    ) -> Single<Result<RegisteredReview, CommentError>>
}

final class DefaultUploadPostUseCase {
    private let imageUploadRepository: ImageUploadRepository
    private let uploadPostRepository: UploadPostRepository
    private let commentRepository: CommentRepository
    
    init(
        imageUploadRepository: ImageUploadRepository,
        uploadPostRepository: UploadPostRepository,
        commentRepository: CommentRepository
    ) {
        self.imageUploadRepository = imageUploadRepository
        self.uploadPostRepository = uploadPostRepository
        self.commentRepository = commentRepository
    }
}

extension DefaultUploadPostUseCase: UploadPostUseCase {
    func uploadImageExecute(files: [Data]) -> Single<Result<UploadedImage, ImageUploadError>> {
        return Single.create { [weak self] single -> Disposable in
            guard let self else {
                single(.success(.failure(.unknown(message: R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            imageUploadRepository.uploadRequest(files: files) { result in
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
    
    func uploadReviewExecute(
        query: UploadBurgerHouseReviewQuery
    ) -> Single<Result<BurgerHouseReview, UploadPostError>> {
        return Single.create { [weak self] single -> Disposable in
            guard let self else {
                single(.success(.failure(.unknown(message: R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            uploadPostRepository.uploadBurgerHouseReview(
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
    
    func registerReviewIdExecute(
        query: RegisterReviewIdQuery
    ) -> Single<Result<RegisteredReview, CommentError>> {
        return Single.create { [weak self] single -> Disposable in
            guard let self else {
                single(.success(.failure(.unknown(message: R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            commentRepository.registerReviewId(
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
}
