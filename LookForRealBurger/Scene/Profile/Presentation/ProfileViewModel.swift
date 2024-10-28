//
//  ProfileViewModel.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/1/24.
//

import Foundation

import RxCocoa
import RxSwift

enum ProfileType {
    case me(_ myUserId: String)
    case other(_ userId: String, _ myUserId: String)
}

protocol ProfileInput {
    func viewDidLoad()
    func backButtonTap()
    func profileRefresh()
    func followLabelTap(followType: FollowType)
    func followOrEditButtonTap()
}

protocol ProfileOutput {
    var setProfile: PublishRelay<GetProfile> { get }
    var setButtonTitle: PublishRelay<String> { get }
    var popPreviousView: PublishRelay<Void> { get }
    var pushEditNick: PublishRelay<String> { get }
    var endRefreshing: PublishRelay<Void> { get }
    var toastMessage: PublishRelay<String> { get }
    var goToLogin: PublishRelay<Void> { get }
    var pushFollowView: PublishRelay<(followType: FollowType,
                                      myUserId: String,
                                      followers: [GetFollow],
                                      followings: [GetFollow])> { get }
}

typealias ProfileViewModel = ProfileInput & ProfileOutput

final class DefaultProfileViewModel: ProfileOutput {
    private let profileUseCase: ProfileUseCase
    private let accessStorage: AccessStorage
    private let disposeBag: DisposeBag
    private let profileType: ProfileType
    private let myUserId: String
    
    private var myProfile: GetProfile?
    private var otherProfile: GetProfile?
    
    var setProfile = PublishRelay<GetProfile>()
    var setButtonTitle = PublishRelay<String>()
    var popPreviousView = PublishRelay<Void>()
    var endRefreshing = PublishRelay<Void>()
    var pushEditNick = PublishRelay<String>()
    var toastMessage = PublishRelay<String>()
    var goToLogin = PublishRelay<Void>()
    var pushFollowView = PublishRelay<(
        followType: FollowType,
        myUserId: String,
        followers: [GetFollow],
        followings: [GetFollow]
    )>()
    
    init(
        ProfileUseCase: ProfileUseCase,
        accessStorage: AccessStorage,
        disposeBag: DisposeBag = DisposeBag(),
        profileType: ProfileType
    ) {
        self.profileUseCase = ProfileUseCase
        self.accessStorage = accessStorage
        self.disposeBag = disposeBag
        self.profileType = profileType
        self.myUserId = accessStorage.loginUserId
    }
}

extension DefaultProfileViewModel: ProfileInput {
    func viewDidLoad() {
        fetchProfile()
    }
    
    func backButtonTap() {
        popPreviousView.accept(())
    }
    
    func profileRefresh() {
        fetchProfile()
    }
    
    func followOrEditButtonTap() {
        switch profileType {
        case .me:
            if let myProfile {
                pushEditNick.accept(myProfile.nick)
            } else {
                pushEditNick.accept(myUserId)
            }
        case .other(let userId, let myUserId):
            if let otherProfile {
                if otherProfile.followers.contains(where: { $0.userId == myUserId }) {
                    followCancel(userId: userId)
                } else {
                    follow(userId: userId)
                }
            }
        }
    }
    
    func followLabelTap(followType: FollowType) {
        if let myProfile {
            pushFollowView.accept((
                followType,
                myProfile.userId,
                myProfile.followers,
                myProfile.following
            ))
        } else if let otherProfile {
            pushFollowView.accept((
                followType,
                myUserId,
                otherProfile.followers,
                otherProfile.following
            ))
        }
    }
    
    private func fetchProfile() {
        switch profileType {
        case .me:
            profileUseCase.getMyProfile()
                .asDriver(onErrorJustReturn: .failure(.unknown(R.Phrase.errorOccurred)))
                .drive(with: self) { owner, result in
                    switch result {
                    case .success(let value):
                        owner.setProfile.accept(value)
                        owner.setButtonTitle.accept(R.Phrase.modifyNick)
                        owner.myProfile = value
                        owner.endRefreshing.accept(())
                    case .failure(let error):
                        switch error {
                        case .network(let message):
                            owner.toastMessage.accept(message)
                        case .invalidToken(let message):
                            owner.toastMessage.accept(message)
                        case .forbidden(let message):
                            owner.toastMessage.accept(message)
                        case .expiredToken:
                            owner.refreshAccessToken {
                                owner.fetchProfile()
                            }
                        case .unknown(let message):
                            owner.toastMessage.accept(message)
                        }
                        owner.endRefreshing.accept(())
                    }
                } onCompleted: { _ in
                    print("getMyProfile completed")
                } onDisposed: { _ in
                    print("getMyProfile disposed")
                }
                .disposed(by: disposeBag)
        case .other(let userID, let myUserId):
            profileUseCase.getOtherProfile(query: .init(userId: userID))
                .asDriver(onErrorJustReturn: .failure(.unknown(R.Phrase.errorOccurred)))
                .drive(with: self) { owner, result in
                    switch result {
                    case .success(let value):
                        owner.setProfile.accept(value)
                        owner.setButtonTitle.accept(
                            value
                                .followers
                                .contains(where: { $0.userId == myUserId }) ? R.Phrase.followCancel : R.Phrase.followRequest
                        )
                        owner.otherProfile = value
                        owner.endRefreshing.accept(())
                    case .failure(let error):
                        switch error {
                        case .network(let message):
                            owner.toastMessage.accept(message)
                        case .invalidToken(let message):
                            owner.toastMessage.accept(message)
                        case .forbidden(let message):
                            owner.toastMessage.accept(message)
                        case .expiredToken:
                            owner.refreshAccessToken {
                                owner.fetchProfile()
                            }
                        case .unknown(let message):
                            owner.toastMessage.accept(message)
                        }
                        owner.endRefreshing.accept(())
                    }
                } onCompleted: { _ in
                    print("getOtherProfile completed")
                } onDisposed: { _ in
                    print("getOtherProfile disposed")
                }
                .disposed(by: disposeBag)
        }
    }
    
    private func follow(userId: String) {
        profileUseCase.followExecute(userId: userId)
            .asDriver(onErrorJustReturn: .failure(.unknown(R.Phrase.errorOccurred)))
            .drive(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.fetchProfile()
                case .failure(let error):
                    switch error {
                    case .network(let message):
                        owner.toastMessage.accept(message)
                    case .badRequest(let message):
                        owner.toastMessage.accept(message)
                    case .invalidToken(let message):
                        owner.toastMessage.accept(message)
                    case .forbidden(let message):
                        owner.toastMessage.accept(message)
                    case .alreadyFollowing(let message):
                        owner.toastMessage.accept(message)
                    case .notFoundUser(let message):
                        owner.toastMessage.accept(message)
                    case .expiredToken:
                        owner.refreshAccessToken {
                            owner.follow(userId: userId)
                        }
                    case .unknown(let message):
                        owner.toastMessage.accept(message)
                    }
                }
            } onCompleted: { _ in
                print("followExecute completed")
            } onDisposed: { _ in
                print("followExecute disposed")
            }
            .disposed(by: disposeBag)
    }
    
    private func followCancel(userId: String) {
        profileUseCase.followCancelExecute(userId: userId)
            .asDriver(onErrorJustReturn: .failure(.unknown(R.Phrase.errorOccurred)))
            .drive(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.fetchProfile()
                case .failure(let error):
                    switch error {
                    case .network(let message):
                        owner.toastMessage.accept(message)
                    case .badRequest(let message):
                        owner.toastMessage.accept(message)
                    case .invalidToken(let message):
                        owner.toastMessage.accept(message)
                    case .forbidden(let message):
                        owner.toastMessage.accept(message)
                    case .alreadyFollowing(let message):
                        owner.toastMessage.accept(message)
                    case .notFoundUser(let message):
                        owner.toastMessage.accept(message)
                    case .expiredToken:
                        owner.refreshAccessToken {
                            owner.follow(userId: userId)
                        }
                    case .unknown(let message):
                        owner.toastMessage.accept(message)
                    }
                }
            } onCompleted: { _ in
                print("followCancelExecute completed")
            } onDisposed: { _ in
                print("followCancelExecute disposed")
            }
            .disposed(by: disposeBag)
    }
}

extension DefaultProfileViewModel {
    private func refreshAccessToken(completion: @escaping () -> Void) {
        profileUseCase.refreshAccessTokenExecute()
            .asDriver(onErrorJustReturn: .failure(.unknown(R.Phrase.errorOccurred)))
            .drive(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.accessStorage.accessToken = value.accessToken
                case .failure(let error):
                    switch error {
                    case .network(let message):
                        owner.toastMessage.accept(message)
                    case .missingFields:
                        break
                    case .accountVerify:
                        break
                    case .invalidToken(let message):
                        owner.toastMessage.accept(message)
                    case .forbidden(let message):
                        owner.toastMessage.accept(message)
                    case .unknown(let message):
                        owner.toastMessage.accept(message)
                    case .existBlank:
                        break
                    case .existUser:
                        break
                    case .enable:
                        break
                    case .expiredRefreshToken:
                        owner.goToLogin.accept(())
                    case .expiredAccessToken:
                        break
                    }
                }
            } onCompleted: { _ in
                print("refreshAccessTokenExecute completed")
            } onDisposed: { _ in
                print("refreshAccessTokenExecute disposed")
            }
            .disposed(by: disposeBag)
    }
}
