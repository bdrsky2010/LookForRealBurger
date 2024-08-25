//
//  LocalSearchUseCase.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/25/24.
//

import Foundation

import RxSwift

protocol LocalSearchUseCase {
    func localSearchExecute(query: LocalSearchQuery) -> Single<Result<BurgerPage, KakaoAPIError>>
}

final class DefaultLocalSearchUseCase {
    private let localSearchRepository: LocalSearchRepository
    
    init(localSearchRepository: LocalSearchRepository) {
        self.localSearchRepository = localSearchRepository
    }
}

extension DefaultLocalSearchUseCase: LocalSearchUseCase {
    func localSearchExecute(query: LocalSearchQuery) -> Single<Result<BurgerPage, KakaoAPIError>> {
        Single.create { [weak self] single in
            guard let self else {
                single(.success(.failure(.unknown(message: R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            localSearchRepository.Request(query: query) { result in
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
