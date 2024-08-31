//
//  BurgerReviewViewModel.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/29/24.
//

import UIKit

import RxCocoa
import RxSwift

protocol BurgerHouseReviewOutput {
    var burgerHouseReviews: BehaviorRelay<[SectionBurgerHouseReview]> { get }
    var pushReviewDetail: PublishRelay<BurgerHouseReview> { get }
    var endRefreshing: PublishRelay<Void> { get }
    var toastMessage: PublishRelay<String> { get }
    var goToLogin: PublishRelay<Void> { get }
}

protocol BurgerHouseReviewInput {
    func viewDidLoad()
    func fetchBurgerHouseReview()
    func firstFetchBurgerHouseReview()
    func nextFetchBurgerHouseReview()
    func refreshAccessToken(completion: @escaping () -> Void)
    func modelSelected(burgerHouseReview: BurgerHouseReview)
}

typealias BurgerHouseReviewViewModel = BurgerHouseReviewInput & BurgerHouseReviewOutput

final class DefaultBurgerHouseReviewViewModel: BurgerHouseReviewOutput {
    private let burgerHouseReviewUseCase: BurgerHouseReviewUseCase
    private let accessStorage: AccessStorage
    private let disposeBag: DisposeBag
    
    var burgerHouseReviews = BehaviorRelay<[SectionBurgerHouseReview]>(value: [])
    var pushReviewDetail = PublishRelay<BurgerHouseReview>()
    var endRefreshing = PublishRelay<Void>()
    var toastMessage = PublishRelay<String>()
    var goToLogin = PublishRelay<Void>()
    
    private var nextCursor: String?
    private let limit = "15"
    
    init(
        burgerReviewUseCase: BurgerHouseReviewUseCase,
        accessStorage: AccessStorage,
        disposeBag: DisposeBag = DisposeBag()
    ) {
        self.burgerHouseReviewUseCase = burgerReviewUseCase
        self.accessStorage = accessStorage
        self.disposeBag = disposeBag
    }
}

extension DefaultBurgerHouseReviewViewModel: BurgerHouseReviewInput {
    func viewDidLoad() {
        firstFetchBurgerHouseReview()
    }
    
    func fetchBurgerHouseReview() {
        burgerHouseReviewUseCase.fetchBurgerReview(
            query: GetPostQuery(
                next: nextCursor,
                limit: limit,
                productId: LFRBProductID.reviewTest.rawValue
            )
        )
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
        guard let nextCursor, nextCursor != "0" else { return }
        fetchBurgerHouseReview()
    }
    
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
    
    func modelSelected(burgerHouseReview: BurgerHouseReview) {
        pushReviewDetail.accept(burgerHouseReview)
    }
}
