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
}

final class DefaultLocalSearchUseCase {
    private let localSearchRepository: LocalSearchRepository
    private let getPostRepository: GetPostRepository
    
    init(
        localSearchRepository: LocalSearchRepository,
        getPostRepository: GetPostRepository
    ) {
        self.localSearchRepository = localSearchRepository
        self.getPostRepository = getPostRepository
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
                    let isExist = !value.filter { $0.localId == localId }.isEmpty
                    single(.success(.success(.init(isExist: isExist))))
                case .failure(let error):
                    single(.success(.failure(error)))
                }
            }
            return Disposables.create()
        }
    }
}
