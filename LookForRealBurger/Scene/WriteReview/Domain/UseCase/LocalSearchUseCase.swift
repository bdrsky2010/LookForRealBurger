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
    ) -> Single<Result<ExistBurgerHouseData, GetPostError>>
    
    func uploadBurgerHouseExecute(
        query: UploadBurgerHouseQuery
    ) -> Single<Result<GetBurgerHouse, UploadPostError>>
}

final class DefaultLocalSearchUseCase {
    private let localSearchRepository: LocalSearchRepository
    private let getPostRepository: GetPostRepository
    private let uploadPostRepository: UploadPostRepository
    
    init(
        localSearchRepository: LocalSearchRepository,
        getPostRepository: GetPostRepository,
        uploadPostRepository: UploadPostRepository
    ) {
        self.localSearchRepository = localSearchRepository
        self.getPostRepository = getPostRepository
        self.uploadPostRepository = uploadPostRepository
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
    ) -> Single<Result<ExistBurgerHouseData, GetPostError>> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.success(.failure(.unknown(message: R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            getPostRepository.getPostRequest(query: query) { result in
                switch result {
                case .success(let value):
                    let filteredList = value.filter { $0.localId == localId }
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
    ) -> Single<Result<GetBurgerHouse, UploadPostError>> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.success(.failure(.unknown(message: R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            uploadPostRepository.uploadBurgerHouse(query: query) { result in
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
