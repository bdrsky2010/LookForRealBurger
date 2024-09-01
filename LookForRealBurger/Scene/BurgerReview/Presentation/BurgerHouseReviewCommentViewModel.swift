//
//  BurgerHouseReviewCommentViewModel.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/1/24.
//

import Foundation

import RxCocoa
import RxSwift

protocol BurgerHouseReviewCommentOutput {
    var configureComments: PublishRelay<[Comment]> { get }
    var toastMessage: PublishRelay<String> { get }
    var goToLogin: PublishRelay<Void> { get }
}

protocol BurgerHouseReviewCommentInput {
    func viewDidLoad()
    func sendButtonTap(text: String)
}

typealias BurgerHouseReviewCommentViewModel = BurgerHouseReviewCommentInput & BurgerHouseReviewCommentOutput

final class DefaultBurgerHouseReviewCommentlViewModel: BurgerHouseReviewCommentOutput {
    private let burgerHouseReviewCommentUseCase: BurgerHouseReviewCommentUseCase
    private let accessStorage: AccessStorage
    private let disposeBag: DisposeBag
    private let postId: String
    private var comments: [Comment]
    
    var configureComments = PublishRelay<[Comment]>()
    var toastMessage = PublishRelay<String>()
    var goToLogin = PublishRelay<Void>()
    
    init(
        burgerHouseReviewCommentUseCase: BurgerHouseReviewCommentUseCase,
        accessStorage: AccessStorage,
        disposeBag: DisposeBag = DisposeBag(),
        postId: String,
        comments: [Comment]
    ) {
        self.burgerHouseReviewCommentUseCase = burgerHouseReviewCommentUseCase
        self.accessStorage = accessStorage
        self.disposeBag = disposeBag
        self.postId = postId
        self.comments = comments
    }
}

extension DefaultBurgerHouseReviewCommentlViewModel: BurgerHouseReviewCommentInput {
    func viewDidLoad() {
        configureComments.accept(comments)
    }
    
    func sendButtonTap(text: String) {
        burgerHouseReviewCommentUseCase.writeCommentExecute(
            query: .init(
                postId: postId,
                content: text
            )
        )
        .asDriver(onErrorJustReturn: .failure(.unknown(message: R.Phrase.errorOccurred)))
        .drive(with: self) { owner, result in
            switch result {
            case .success(let value):
                owner.comments.insert(value, at: 0)
                owner.configureComments.accept(owner.comments)
            case .failure(let error):
                switch error {
                case .network(let message):
                    owner.toastMessage.accept(message)
                case .missingData(let message):
                    owner.toastMessage.accept(message)
                case .invalidToken(let message):
                    owner.toastMessage.accept(message)
                case .forbidden(let message):
                    owner.toastMessage.accept(message)
                case .commentFail(let message):
                    owner.toastMessage.accept(message)
                case .expiredToken:
                    owner.refreshAccessToken {
                        owner.sendButtonTap(text: text)
                    }
                case .unknown(let message):
                    owner.toastMessage.accept(message)
                }
            }
        } onCompleted: { _ in
            print("writeCommentExecute completed")
        } onDisposed: { _ in
            print("writeCommentExecute disposed")
        }
        .disposed(by: disposeBag)
    }
}

extension DefaultBurgerHouseReviewCommentlViewModel {
    private func refreshAccessToken(completion: @escaping () -> Void) {
        burgerHouseReviewCommentUseCase.refreshAccessTokenExecute()
            .asDriver(onErrorJustReturn: .failure(.unknown(R.Phrase.errorOccurred)))
            .drive(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.accessStorage.accessToken = value.accessToken
                    completion()
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
