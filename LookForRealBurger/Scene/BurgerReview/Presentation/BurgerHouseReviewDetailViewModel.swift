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
    var configureViewContents: PublishRelay<BurgerHouseReview> { get }
    var configureReviewImages: PublishRelay<[SectionImageType]> { get }
}

protocol BurgerHouseReviewDetailInput {
    func tapBackButton()
    func viewDidLoad()
}

typealias BurgerHouseReviewDetailViewModel = BurgerHouseReviewDetailInput & BurgerHouseReviewDetailOutput

final class DefaultBurgerHouseReviewDetailViewModel: BurgerHouseReviewDetailOutput {
    private let burgerHouseReviewDetailUseCase: BurgerHouseReviewDetailUseCase
    private let accessStorage: AccessStorage
    private let disposeBag: DisposeBag
    private var burgerHouseReview: BurgerHouseReview
    
    var popViewController = PublishRelay<Void>()
    var configureViewContents = PublishRelay<BurgerHouseReview>()
    var configureReviewImages = PublishRelay<[SectionImageType]>()
    
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
        configureViewContents.accept(burgerHouseReview)
        configureReviewImages.accept([SectionImageType(items: burgerHouseReview.files)])
    }
}
