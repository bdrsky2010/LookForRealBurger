//
//  BurgerMapHouseViewModel.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/29/24.
//

import Foundation

import RxCocoa
import RxSwift

protocol BurgerMapHouseInput {
    func viewDidLoad()
    func fetchReviews()
    func fetchSingleReview(postId: String, completion: @escaping (BurgerHouseReview) -> Void)
    func refreshAccessToken(completion: @escaping () -> Void)
}

protocol BurgerMapHouseOutput {
    var setBurgerHouse: BehaviorRelay<(name: String, roadAddress: String, phone: String)> { get }
    var burgerHouseReviews: BehaviorSubject<[SectionBurgerHouseReview]> { get }
    var toastMessage: PublishRelay<String> { get }
    var goToLogin: PublishRelay<Void> { get }
}

typealias BurgerMapHouseViewModel = BurgerMapHouseInput & BurgerMapHouseOutput

final class DefaultBurgerMapHouseViewModel: BurgerMapHouseOutput {
    private let burgerMapHouseUseCase: BurgerMapHouseUseCase
    private let accessStorage: AccessStorage
    private let disposeBag: DisposeBag
    private var burgerMapHouse: BurgerMapHouse
    
    var setBurgerHouse = BehaviorRelay<(name: String, roadAddress: String, phone: String)>(value: ("", "", ""))
    var burgerHouseReviews = BehaviorSubject<[SectionBurgerHouseReview]>(value: [])
    var toastMessage = PublishRelay<String>()
    var goToLogin = PublishRelay<Void>()
    
    init(
        burgerMapHouseUseCase: BurgerMapHouseUseCase,
        accessStorage: AccessStorage,
        disposeBag: DisposeBag = DisposeBag(),
        burgerMapHouse: BurgerMapHouse
    ) {
        self.burgerMapHouseUseCase = burgerMapHouseUseCase
        self.accessStorage = accessStorage
        self.disposeBag = disposeBag
        self.burgerMapHouse = burgerMapHouse
    }
}

extension DefaultBurgerMapHouseViewModel: BurgerMapHouseInput {
    func viewDidLoad() {
        setBurgerHouse.accept((burgerMapHouse.name, burgerMapHouse.roadAddress, burgerMapHouse.phone))
        fetchReviews()
    }
    
    func fetchReviews() {
        burgerMapHouse.reviewIds.forEach { postId in
            fetchSingleReview(postId: postId) { [weak self] review in
                guard let self else { return }
                do {
                    if var reviews = try burgerHouseReviews.value().first {
                        reviews.items.append(review)
                        reviews.items = reviews.items.sorted { $0.createdAt > $1.createdAt }
                        burgerHouseReviews.onNext([reviews])
                    } else {
                        burgerHouseReviews.onNext([SectionBurgerHouseReview(items: [review])])
                    }
                } catch {
                    toastMessage.accept("왜 에러가 여기서..?")
                }
            }
        }
    }
    
    func fetchSingleReview(postId: String, completion: @escaping (BurgerHouseReview) -> Void) {
        burgerMapHouseUseCase.fetchSinglePostExecute(
            query: .init(postId: postId)
        )
        .asDriver(onErrorJustReturn: .failure(.unknown(R.Phrase.errorOccurred)))
        .drive(with: self) { owner, result in
            switch result {
            case .success(let value):
                completion(value)
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
                        owner.fetchSingleReview(postId: postId) {
                            completion($0)
                        }
                    }
                case .unknown(let message):
                    owner.toastMessage.accept(message)
                case .invalidValue(_):
                    break
                case .dbServer(_):
                    break
                }
            }
        } onCompleted: { _ in
            print("fetchSinglePostExecute completed")
        } onDisposed: { _ in
            print("fetchSinglePostExecute disposed")
        }
        .disposed(by: disposeBag)
    }
    
    func refreshAccessToken(completion: @escaping () -> Void) {
        burgerMapHouseUseCase.refreshAccessTokenExecute()
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
