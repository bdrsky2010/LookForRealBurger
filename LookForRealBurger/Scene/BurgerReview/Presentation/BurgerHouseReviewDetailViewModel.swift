//
//  BurgerReviewDetailViewModel.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/29/24.
//

import Foundation

import RxCocoa
import RxSwift

protocol BurgerHouseReviewDetailOutput {
    var popViewController: PublishRelay<Void> { get }
    var configureViewContents: BehaviorRelay<[BurgerHouseReview]> { get }
    var configureReviewImages: PublishRelay<[SectionImageType]> { get }
    var isMyReview: PublishRelay<Bool> { get }
    var isLike: BehaviorRelay<Bool> { get }
    var likeCount: BehaviorRelay<Int> { get }
    var commentCount: PublishRelay<Int> { get }
    var isBookmark: BehaviorRelay<Bool> { get }
    var bookmarkCount: BehaviorRelay<Int> { get }
    var pushCommentView: PublishRelay<(postId: String, comments: [Comment])> { get }
    var toastMessage: PublishRelay<String> { get }
    var goToLogin: PublishRelay<Void> { get }
}

protocol BurgerHouseReviewDetailInput {
    func tapBackButton()
    func viewDidLoad()
    func likeTap()
    func commentTap()
    func bookmarkTap()
    func onChangeComments(comments: [Comment])
}

typealias BurgerHouseReviewDetailViewModel = BurgerHouseReviewDetailInput & BurgerHouseReviewDetailOutput

final class DefaultBurgerHouseReviewDetailViewModel: BurgerHouseReviewDetailOutput {
    private let burgerHouseReviewDetailUseCase: BurgerHouseReviewDetailUseCase
    private let accessStorage: AccessStorage
    private let disposeBag: DisposeBag
    
    private var burgerHouseReview: BurgerHouseReview
    private var myUserId: GetMyUserId?
    
    var popViewController = PublishRelay<Void>()
    var configureViewContents = BehaviorRelay<[BurgerHouseReview]>(value: [])
    var configureReviewImages = PublishRelay<[SectionImageType]>()
    var isMyReview = PublishRelay<Bool>()
    var isLike = BehaviorRelay<Bool>(value: false)
    var likeCount = BehaviorRelay<Int>(value: 0)
    var commentCount = PublishRelay<Int>()
    var isBookmark = BehaviorRelay<Bool>(value: false)
    var bookmarkCount = BehaviorRelay<Int>(value: 0)
    var pushCommentView = PublishRelay<(postId: String, comments: [Comment])>()
    var toastMessage = PublishRelay<String>()
    var goToLogin = PublishRelay<Void>()
    
    init(
        burgerHouseReviewDetailUseCase: BurgerHouseReviewDetailUseCase,
        accessStorage: AccessStorage,
        disposeBag: DisposeBag = DisposeBag(),
        burgerHouseReview: BurgerHouseReview
    ) {
        self.burgerHouseReviewDetailUseCase = burgerHouseReviewDetailUseCase
        self.accessStorage = accessStorage
        self.disposeBag = disposeBag
        self.burgerHouseReview = burgerHouseReview
    }
}

extension DefaultBurgerHouseReviewDetailViewModel: BurgerHouseReviewDetailInput {
    func tapBackButton() {
        popViewController.accept(())
    }
    
    func viewDidLoad() {
        configureViewContents.accept([burgerHouseReview])
        configureReviewImages.accept([SectionImageType(items: burgerHouseReview.files)])
        likeCount.accept(burgerHouseReview.likeUserIds.count)
        commentCount.accept(burgerHouseReview.comments.count)
        bookmarkCount.accept(burgerHouseReview.bookmarkUserIds.count)
        getMyUserId()
    }
    
    func likeTap() {
        let isLikeValue = !isLike.value
        isLike.accept(isLikeValue)
        burgerHouseReviewDetailUseCase.getIsLikePostExecute(
            query: .init(
                postId: burgerHouseReview.id,
                likeStatus: isLikeValue
            )
        )
        .asDriver(onErrorJustReturn: .failure(.unknown(message: R.Phrase.errorOccurred)))
        .drive(with: self) { owner, result in
            switch result {
            case .success(let value):
                owner.isLike.accept(value.isLike)
                owner.likeCount.accept(value.isLike ? owner.likeCount.value + 1 : owner.likeCount.value - 1)
            case .failure(let error):
                switch error {
                case .network(message: let message):
                    owner.toastMessage.accept(message)
                case .badRequest(message: let message):
                    owner.toastMessage.accept(message)
                case .invalidToken(message: let message):
                    owner.toastMessage.accept(message)
                case .forbidden(message: let message):
                    owner.toastMessage.accept(message)
                case .notFoundPost(message: let message):
                    owner.toastMessage.accept(message)
                case .expiredToken:
                    owner.refreshAccessToken {
                        owner.likeTap()
                    }
                case .unknown(message: let message):
                    owner.toastMessage.accept(message)
                }
            }
        } onCompleted: { _ in
            print("getIsLikePostExecute completed")
        } onDisposed: { _ in
            print("getIsLikePostExecute disposed")
        }
        .disposed(by: disposeBag)
    }
    
    func commentTap() {
        pushCommentView.accept(
            (
                burgerHouseReview.id,
                burgerHouseReview.comments
            )
        )
    }
    
    func bookmarkTap() {
        let isBookmarkValue = !isBookmark.value
        isBookmark.accept(isBookmarkValue)
        burgerHouseReviewDetailUseCase.getIsBookmarkPostExecute(
            query: .init(
                postId: burgerHouseReview.id,
                bookmarkStatus: isBookmarkValue
            )
        )
        .asDriver(onErrorJustReturn: .failure(.unknown(message: R.Phrase.errorOccurred)))
        .drive(with: self) { owner, result in
            switch result {
            case .success(let value):
                owner.isBookmark.accept(value.isBookmark)
                owner.bookmarkCount.accept(value.isBookmark ? owner.bookmarkCount.value + 1 : owner.bookmarkCount.value - 1)
            case .failure(let error):
                switch error {
                case .network(message: let message):
                    owner.toastMessage.accept(message)
                case .badRequest(message: let message):
                    owner.toastMessage.accept(message)
                case .invalidToken(message: let message):
                    owner.toastMessage.accept(message)
                case .forbidden(message: let message):
                    owner.toastMessage.accept(message)
                case .notFoundPost(message: let message):
                    owner.toastMessage.accept(message)
                case .expiredToken:
                    owner.refreshAccessToken {
                        owner.likeTap()
                    }
                case .unknown(message: let message):
                    owner.toastMessage.accept(message)
                }
            }
        } onCompleted: { _ in
            print("getIsBookmarkPostExecute completed")
        } onDisposed: { _ in
            print("getIsBookmarkPostExecute disposed")
        }
        .disposed(by: disposeBag)
    }
    
    private func getMyUserId() {
        burgerHouseReviewDetailUseCase.getMyUserIdExecute()
            .asDriver(onErrorJustReturn: .failure(.unknown(R.Phrase.errorOccurred)))
            .drive(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.myUserId = value
                    owner.isMyReview.accept(value.userId == owner.burgerHouseReview.creator.userId)
                    owner.isLike.accept(owner.burgerHouseReview.likeUserIds.contains(value.userId))
                    owner.isBookmark.accept(owner.burgerHouseReview.bookmarkUserIds.contains(value.userId))
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
                            owner.getMyUserId()
                        }
                    case .unknown(let message):
                        owner.toastMessage.accept(message)
                    }
                }
            } onCompleted: { _ in
                print("getMyUserIdExecute completed")
            } onDisposed: { _ in
                print("getMyUserIdExecute disposed")
            }
            .disposed(by: disposeBag)
    }
    
    private func refreshAccessToken(completion: @escaping () -> Void) {
        burgerHouseReviewDetailUseCase.refreshAccessTokenExecute()
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
    
    func onChangeComments(comments: [Comment]) {
        guard var review = configureViewContents.value.first else { return }
        review.comments = comments
        configureViewContents.accept([review])
        commentCount.accept(comments.count)
        burgerHouseReview = review
    }
}
