//
//  PostUploadUseCase.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/26/24.
//

import Foundation

import RxSwift

protocol UploadPostUseCase {
    func uploadImage(files: [Data]) -> Single<Result<UploadedImage, ImageUploadError>>
}

final class DefaultUploadPostUseCase {
    private let imageUploadRepository: ImageUploadRepository
    private let uploadPostRepository: UploadPostRepository
    
    init(
        imageUploadRepository: ImageUploadRepository,
        uploadPostRepository: UploadPostRepository
    ) {
        self.imageUploadRepository = imageUploadRepository
        self.uploadPostRepository = uploadPostRepository
    }
}

extension DefaultUploadPostUseCase: UploadPostUseCase {
    func uploadImage(files: [Data]) -> Single<Result<UploadedImage, ImageUploadError>> {
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
}
