//
//  ProfileUseCase.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/1/24.
//

import Foundation

import RxSwift

protocol ProfileUseCase {
    func getMyProfile() -> Single<Result<GetProfile, ProfileError>>
    func getOtherProfile(query: GetOtherProfileQuery) -> Single<Result<GetProfile, ProfileError>>
    func refreshAccessTokenExecute() -> Single<Result<AccessToken, AuthError>>
}

final class DefaultProfileUseCase {
    private let profileRepository: ProfileRepository
    private let authRepository: AuthRepository
    
    init(
        profileRepository: ProfileRepository,
        authRepository: AuthRepository
    ) {
        self.profileRepository = profileRepository
        self.authRepository = authRepository
    }
}

extension DefaultProfileUseCase: ProfileUseCase {
    func getMyProfile() -> Single<Result<GetProfile, ProfileError>> {
        return Single.create { [weak self] single -> Disposable in
            guard let self else {
                single(.success(.failure(.unknown(R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            profileRepository.myProfileRequest { result in
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
    
    func getOtherProfile(
        query: GetOtherProfileQuery
    ) -> Single<Result<GetProfile, ProfileError>> {
        return Single.create { [weak self] single -> Disposable in
            guard let self else {
                single(.success(.failure(.unknown(R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            profileRepository.getOtherProfileRequest(query: query) { result in
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
