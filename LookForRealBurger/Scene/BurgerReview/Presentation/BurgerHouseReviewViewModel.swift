//
//  BurgerReviewViewModel.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/29/24.
//

import UIKit

import RxCocoa
import RxSwift

protocol BurgerHouseReviewInput {
    func viewDidLoad()
    func firstFetchBurgerHouseReview()
    func nextFetchBurgerHouseReview()
    func modelSelected(burgerHouseReview: BurgerHouseReview)
    func refreshAccessToken(completion: @escaping () -> Void)
}

protocol BurgerHouseReviewOutput {
    var burgerHouseReviews: BehaviorRelay<[SectionBurgerHouseReview]> { get }
    var pushReviewDetail: PublishRelay<BurgerHouseReview> { get }
    var endRefreshing: PublishRelay<Void> { get }
    var toastMessage: PublishRelay<String> { get }
    var goToLogin: PublishRelay<Void> { get }
    var nextCursor: String? { get }
}

typealias BurgerHouseReviewViewModel = BurgerHouseReviewInput & BurgerHouseReviewOutput

enum GetPostType {
    case total
    case byUser(_ userId: String)
    case myLike
    case myLike2
}

final class DefaultBurgerHouseReviewViewModel: BurgerHouseReviewOutput {
    private let burgerHouseReviewUseCase: BurgerHouseReviewUseCase
    private let accessStorage: AccessStorage
    private let getPostType: GetPostType
    private let disposeBag: DisposeBag
    
    var burgerHouseReviews = BehaviorRelay<[SectionBurgerHouseReview]>(value: [])
    var pushReviewDetail = PublishRelay<BurgerHouseReview>()
    var endRefreshing = PublishRelay<Void>()
    var toastMessage = PublishRelay<String>()
    var goToLogin = PublishRelay<Void>()
    
    private var isFetching = false
    private(set) var nextCursor: String?
    private let limit = "21"
    
    init(
        burgerReviewUseCase: BurgerHouseReviewUseCase,
        accessStorage: AccessStorage,
        getPostType: GetPostType,
        disposeBag: DisposeBag = DisposeBag()
    ) {
        self.burgerHouseReviewUseCase = burgerReviewUseCase
        self.accessStorage = accessStorage
        self.getPostType = getPostType
        self.disposeBag = disposeBag
    }
}

extension DefaultBurgerHouseReviewViewModel: BurgerHouseReviewInput {
    func viewDidLoad() {
        firstFetchBurgerHouseReview()
    }
    
    private func fetchBurgerHouseReview() {
        let query = GetPostQuery(
            type: getPostType,
            next: nextCursor,
            limit: limit
        )
        isFetching = true
        
        burgerHouseReviewUseCase.fetchBurgerReview(query: query)
        .asDriver(onErrorJustReturn: .failure(.unknown(R.Phrase.errorOccurred)))
        .drive(with: self) { owner, result in
            switch result {
            case .success(let value):
                if owner.nextCursor == .none {
                    owner.burgerHouseReviews.accept([SectionBurgerHouseReview(items: value.reviews)])
                } else {
                    var reviews = owner.burgerHouseReviews.value[0]
                    reviews.items.append(contentsOf: value.reviews)
                    owner.burgerHouseReviews.accept([reviews])
                }
                owner.nextCursor = value.nextCursor
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
                case .expiredToken:
                    owner.refreshAccessToken {
                        owner.fetchBurgerHouseReview()
                    }
                case .unknown(let message):
                    owner.toastMessage.accept(message)
                case .invalidValue(_):
                    break
                case .dbServer(_):
                    break
                }
            }
            owner.isFetching = false
            owner.endRefreshing.accept(())
        } onCompleted: { _ in
            print("fetchBurgerReview completed")
        } onDisposed: { _ in
            print("fetchBurgerReview disposed")
        }
        .disposed(by: disposeBag)
    }
    
    func firstFetchBurgerHouseReview() {
        nextCursor = nil
        fetchBurgerHouseReview()
    }
    
    func nextFetchBurgerHouseReview() {
        guard let nextCursor, nextCursor != "0", !isFetching else { return }
        fetchBurgerHouseReview()
    }
    
    func modelSelected(burgerHouseReview: BurgerHouseReview) {
        pushReviewDetail.accept(burgerHouseReview)
    }
}

extension DefaultBurgerHouseReviewViewModel {
    func refreshAccessToken(completion: @escaping () -> Void) {
        burgerHouseReviewUseCase.refreshAccessTokenExecute()
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
