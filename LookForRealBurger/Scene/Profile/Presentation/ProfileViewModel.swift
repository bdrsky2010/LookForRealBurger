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
    case me
    case other(_ userId: String)
}

protocol ProfileOutput {
    var setProfile: PublishRelay<GetProfile> { get }
    var popPreviousView: PublishRelay<Void> { get }
    var toastMessage: PublishRelay<String> { get }
    var goToLogin: PublishRelay<Void> { get }
}

protocol ProfileInput {
    func viewDidLoad()
    func backButtonTap()
}

typealias ProfileViewModel = ProfileInput & ProfileOutput

final class DefaultProfileViewModel: ProfileOutput {
    private let profileUseCase: ProfileUseCase
    private let accessStorage: AccessStorage
    private let disposeBag: DisposeBag
    private let profileType: ProfileType
    
    var setProfile = PublishRelay<GetProfile>()
    var popPreviousView = PublishRelay<Void>()
    var toastMessage = PublishRelay<String>()
    var goToLogin = PublishRelay<Void>()
    
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
    }
}

extension DefaultProfileViewModel: ProfileInput {
    func viewDidLoad() {
        fetchProfile()
    }
    
    func backButtonTap() {
        popPreviousView.accept(())
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
                    }
                } onCompleted: { _ in
                    print("getMyProfile completed")
                } onDisposed: { _ in
                    print("getMyProfile disposed")
                }
                .disposed(by: disposeBag)
        case .other(let userID):
            profileUseCase.getOtherProfile(query: .init(userId: userID))
                .asDriver(onErrorJustReturn: .failure(.unknown(R.Phrase.errorOccurred)))
                .drive(with: self) { owner, result in
                    switch result {
                    case .success(let value):
                        owner.setProfile.accept(value)
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
                    }
                } onCompleted: { _ in
                    print("getMyProfile completed")
                } onDisposed: { _ in
                    print("getMyProfile disposed")
                }
                .disposed(by: disposeBag)
        }
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
