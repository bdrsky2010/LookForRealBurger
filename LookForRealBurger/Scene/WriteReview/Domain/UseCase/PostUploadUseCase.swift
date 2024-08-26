//
//  PostUploadUseCase.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/26/24.
//

import Foundation

import RxSwift

protocol PostUploadUseCase {
    func uploadImage(files: [Data]) -> Single<Result<UploadedImage, ImageUploadError>>
}

final class DefaultPostUploadUseCase {
    private let imageUploadRepository: ImageUploadRepository
    private let postUploadRepository: PostUploadRepository
    
    init(
        imageUploadRepository: ImageUploadRepository,
        postUploadRepository: PostUploadRepository
    ) {
        self.imageUploadRepository = imageUploadRepository
        self.postUploadRepository = postUploadRepository
    }
}

extension DefaultPostUploadUseCase: PostUploadUseCase {
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
