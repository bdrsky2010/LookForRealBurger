//
//  FollowListViewModel.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/2/24.
//

import Foundation

import RxCocoa
import RxSwift

protocol FollowListInput {
    func viewDidLoad()
    func modelSelected(follow: GetFollow)
}

protocol FollowListOutput {
    var configureTableView: BehaviorRelay<[GetFollow]> { get }
    var pushProfileView: PublishRelay<ProfileType> { get }
    var toastMessage: PublishRelay<String> { get }
    var goToLogin: PublishRelay<Void> { get }
}

typealias FollowListViewModel = FollowListInput & FollowListOutput

final class DefaultFollowListViewModel: FollowListOutput {
    private let followListUseCase: FollowListUseCase
    private let accessStorage: AccessStorage
    private let disposeBag: DisposeBag
    private let myUserId: String
    private let followList: [GetFollow]
    
    var configureTableView = BehaviorRelay<[GetFollow]>(value: [])
    var pushProfileView = PublishRelay<ProfileType>()
    var toastMessage = PublishRelay<String>()
    var goToLogin = PublishRelay<Void>()
    
    init(
        followListUseCase: FollowListUseCase,
        accessStorage: AccessStorage,
        disposBag: DisposeBag = DisposeBag(),
        myUserId: String,
        followList: [GetFollow]
    ) {
        self.followListUseCase = followListUseCase
        self.accessStorage = accessStorage
        self.disposeBag = disposBag
        self.myUserId = myUserId
        self.followList = followList
    }
}

extension DefaultFollowListViewModel: FollowListInput {
    func viewDidLoad() {
//        followList.forEach {
//            getProfile(userId: $0)
//        }
        print(followList)
        configureTableView.accept(followList)
    }
    
    func modelSelected(follow: GetFollow) {
        print(follow, myUserId)
        if follow.userId == myUserId {
            pushProfileView.accept(.me)
        } else {
            pushProfileView.accept(.other(follow.userId, myUserId))
        }
    }
}

extension DefaultFollowListViewModel {
    private func getProfile(userId: String) {
        followListUseCase.getProfileExecute(query: .init(userId: userId))
            .asDriver(onErrorJustReturn: .failure(.unknown(R.Phrase.errorOccurred)))
            .drive(with: self) { owner, result in
                switch result {
                case .success(let value):
                    break
//                    var data = owner.configureTableView.value
//                    data.append(value)
//                    data.sort(by: { $0.nick < $1.nick })
//                    owner.configureTableView.accept(data)
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
                            owner.getProfile(userId: userId)
                        }
                    case .unknown(let message):
                        owner.toastMessage.accept(message)
                    }
                }
            } onCompleted: { _ in
                print("getProfileExecute completed")
            } onDisposed: { _ in
                print("getProfileExecute disposed")
            }
            .disposed(by: disposeBag)
    }
    
    private func refreshAccessToken(completion: @escaping () -> Void) {
        followListUseCase.refreshAccessTokenExecute()
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
