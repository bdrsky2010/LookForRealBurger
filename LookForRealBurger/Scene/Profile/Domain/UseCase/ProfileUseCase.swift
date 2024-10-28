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
    func followExecute(userId: String) -> Single<Result<GetFollowStatus, FollowError>>
    func followCancelExecute(userId: String) -> Single<Result<GetFollowStatus, FollowError>>
    func refreshAccessTokenExecute() -> Single<Result<AccessToken, AuthError>>
}

final class DefaultProfileUseCase {
    private let profileRepository: ProfileRepository
    private let followRepository: FollowRepository
    private let authRepository: AuthRepository
    
    init(
        profileRepository: ProfileRepository,
        followRepository: FollowRepository,
        authRepository: AuthRepository
    ) {
        self.profileRepository = profileRepository
        self.followRepository = followRepository
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
    
    func followExecute(
        userId: String
    ) -> Single<Result<GetFollowStatus, FollowError>> {
        return Single.create { [weak self] single -> Disposable in
            guard let self else {
                single(.success(.failure(.unknown(R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            followRepository.followRequest(userId: userId) { result in
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
    
    func followCancelExecute(
        userId: String
    ) -> Single<Result<GetFollowStatus, FollowError>> {
        return Single.create { [weak self] single -> Disposable in
            guard let self else {
                single(.success(.failure(.unknown(R.Phrase.errorOccurred))))
                return Disposables.create()
            }
            followRepository.followCancelRequest(userId: userId) { result in
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

extension ProfileUseCase {
    func setSuccess(_ flag: Bool) { }
    func setFollow(_ flag: Bool) { }
}

final class MockProfileUseCase: ProfileUseCase {
    private var isSuccess = false
    private var isFollow = false
    
    func getMyProfile() -> Single<Result<GetProfile, ProfileError>> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.success(.failure(.unknown(""))))
                return Disposables.create()
            }
            
            if isSuccess {
                single(.success(.success(GetProfile(userId: "me", nick: "", followers: [GetFollow(userId: "other", nick: ""), GetFollow(userId: "another", nick: "")], following: [GetFollow(userId: "other", nick: "")], posts: []))))
            } else {
                single(.success(.failure(.unknown(""))))
            }
            
            return Disposables.create()
        }
    }
    
    func getOtherProfile(query: GetOtherProfileQuery) -> Single<Result<GetProfile, ProfileError>> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.success(.failure(.unknown(""))))
                return Disposables.create()
            }
            
            if isSuccess {
                if isFollow {
                    single(.success(.success(GetProfile(userId: "other", nick: "", followers: [GetFollow(userId: "me", nick: "")], following: [], posts: []))))
                } else {
                    single(.success(.success(GetProfile(userId: "other", nick: "", followers: [], following: [], posts: []))))
                }
            } else {
                single(.success(.failure(.unknown(""))))
            }
            
            return Disposables.create()
        }
    }
    
    func followExecute(userId: String) -> Single<Result<GetFollowStatus, FollowError>> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.success(.failure(.unknown(""))))
                return Disposables.create()
            }
            
            if isSuccess {
                single(.success(.success(GetFollowStatus(followingStatus: true))))
            } else {
                single(.success(.failure(.unknown(""))))
            }
            
            return Disposables.create()
        }
    }
    
    func followCancelExecute(userId: String) -> Single<Result<GetFollowStatus, FollowError>> {
        return Single.create { [weak self] single in
            guard let self else {
                single(.success(.failure(.unknown(""))))
                return Disposables.create()
            }
            
            if isSuccess {
                single(.success(.success(GetFollowStatus(followingStatus: false))))
            } else {
                single(.success(.failure(.unknown(""))))
            }
            
            return Disposables.create()
        }
    }
    
    func refreshAccessTokenExecute() -> Single<Result<AccessToken, AuthError>> {
        return Single.create { single in
            single(.success(.success(AccessToken(accessToken: ""))))
            return Disposables.create()
        }
    }
    
    func setSuccess(_ flag: Bool) { isSuccess = flag }
    func setFollow(_ flag: Bool) { isFollow = flag }
}
