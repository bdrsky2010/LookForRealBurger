//
//  WriteReviewViewModel.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/25/24.
//

import Foundation

import RxCocoa
import RxSwift

protocol WriteReviewInput {
    func xButtonTap()
    func searchBarTap()
    func burgerHouseSelect(burgerHouse: BurgerHouse)
    func imageTap()
    func cameraSelect()
    func gallerySelect()
    func saveTap()
    func uploadImage(files: [Data])
    func plusRatingTap()
    func minusRatingTap()
    func uploadPost(title: String, content: String, files: UploadedImage)
    func missingField()
    func registerReviewId(burgerHousePostId: String, reviewId: String)
}

protocol WriteReviewOutput {
    var goToPreviousTab: PublishRelay<Void> { get }
    var goToLocalSearch: PublishRelay<Void> { get }
    var selectedBurgerHouse: PublishRelay<String> { get }
    var presentAddPhotoAction: PublishRelay<Void> { get }
    var presentCamera: PublishRelay<Void> { get }
    var presentGallery: PublishRelay<Void> { get }
    var burgerHouseRating: BehaviorRelay<Int> { get }
    var toastMessage: PublishRelay<String> { get }
    var saveConfirm: PublishRelay<Void> { get }
    var uploadImageSuccess: PublishRelay<UploadedImage> { get }
    var didSuccessUploadReview: PublishRelay<Void> { get }
    var goToLogin: PublishRelay<Void> { get }
}

typealias WriteReviewViewModel = WriteReviewInput & WriteReviewOutput

final class DefaultWriteReviewViewModel: WriteReviewOutput {
    var goToPreviousTab = PublishRelay<Void>()
    var goToLocalSearch = PublishRelay<Void>()
    var selectedBurgerHouse = PublishRelay<String>()
    var presentAddPhotoAction = PublishRelay<Void>()
    var presentCamera = PublishRelay<Void>()
    var presentGallery = PublishRelay<Void>()
    var burgerHouseRating = BehaviorRelay<Int>(value: 5)
    var toastMessage = PublishRelay<String>()
    var saveConfirm = PublishRelay<Void>()
    var uploadImageSuccess = PublishRelay<UploadedImage>()
    var didSuccessUploadReview = PublishRelay<Void>()
    var goToLogin = PublishRelay<Void>()
    
    private var burgerHouse: BurgerHouse?
    private let accessStorage: AccessStorage
    private var uploadPostUseCase: UploadPostUseCase!
    private var disposeBag: DisposeBag!
    
    init(
        uploadPostUseCase: UploadPostUseCase,
        accessStorage: AccessStorage,
        disposeBag: DisposeBag = DisposeBag()
    ) {
        self.uploadPostUseCase = uploadPostUseCase
        self.accessStorage = accessStorage
        self.disposeBag = disposeBag
    }
    
    deinit {
        print("WriteReviewViewModel deinit")
    }
}

extension DefaultWriteReviewViewModel: WriteReviewInput {
    func xButtonTap() {
        goToPreviousTab.accept(())
    }
    
    func searchBarTap() {
        goToLocalSearch.accept(())
    }
    
    func burgerHouseSelect(burgerHouse: BurgerHouse) {
        Observable.just(burgerHouse.name)
            .bind(onNext: selectedBurgerHouse.accept(_:))
            .disposed(by: disposeBag)
        self.burgerHouse = burgerHouse
    }
    
    func imageTap() {
        presentAddPhotoAction.accept(())
    }
    
    func cameraSelect() {
        presentCamera.accept(())
    }
    
    func gallerySelect() {
        presentGallery.accept(())
    }
    
    func saveTap() {
        saveConfirm.accept(())
    }
    
    func uploadImage(files: [Data]) {
        guard !files.isEmpty else {
            toastMessage.accept(R.Phrase.plzImageUpload)
            return
        }
        guard files.reduce(0, { $0 + $1.count }) < 5000000,
              files.count <= 5 else {
            toastMessage.accept(R.Phrase.limitImageSize)
            return
        }
        
        uploadPostUseCase.uploadImageExecute(files: files)
            .asDriver(onErrorJustReturn: .failure(.unknown(R.Phrase.errorOccurred)))
            .drive(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.uploadImageSuccess.accept(value)
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
                            owner.uploadImage(files: files)
                        }
                    case .unknown(let message):
                        owner.toastMessage.accept(message)
                    case .invalidValue(let message):
                        owner.toastMessage.accept(message)
                    case .dbServer(let message):
                        owner.toastMessage.accept(message)
                    }
                }
            } onCompleted: { _ in
                print("uploadImage completed")
            } onDisposed: { _ in
                print("uploadImage disposed")
            }
            .disposed(by: disposeBag)
    }
    
    func plusRatingTap() {
        var rating = burgerHouseRating.value
        rating = rating < 5 ? (rating + 1) : rating
        burgerHouseRating.accept(rating)
    }
    
    func minusRatingTap() {
        var rating = burgerHouseRating.value
        rating = rating > 1 ? (rating - 1) : rating
        burgerHouseRating.accept(rating)
    }
    
    func uploadPost(title: String, content: String, files: UploadedImage) {
        guard let burgerHouseId = burgerHouse?.burgerHousePostId else {
            toastMessage.accept(R.Phrase.plzSelectBurgerHouse)
            return
        }
        
        let rating = burgerHouseRating.value
        let uploadPostQuery = UploadBurgerHouseReviewQuery(
            title: title,
            rating: rating,
            content: content,
            burgerHousePostId: burgerHouseId,
            files: files.paths)
        
        uploadPostUseCase.uploadReviewExecute(query: uploadPostQuery)
            .asDriver(onErrorJustReturn: .failure(.unknown(R.Phrase.errorOccurred)))
            .drive(with: self) { owner, result in
                switch result {
                case .success(let value):
                    print(value)
                    owner.registerReviewId(
                        burgerHousePostId: value.burgerHousePostId,
                        reviewId: value.id
                    )
                case .failure(let error):
                    switch error {
                    case .network(let message):
                        owner.toastMessage.accept(message)
                    case .invalidValue(let message):
                        owner.toastMessage.accept(message)
                    case .invalidToken(let message):
                        owner.toastMessage.accept(message)
                    case .forbidden(let message):
                        owner.toastMessage.accept(message)
                    case .dbServer(let message):
                        owner.toastMessage.accept(message)
                    case .expiredToken:
                        owner.refreshAccessToken {
                            owner.uploadPost(title: title, content: content, files: files)
                        }
                    case .unknown(let message):
                        owner.toastMessage.accept(message)
                    case .badRequest(let message):
                        owner.toastMessage.accept(message)
                    }
                }
            } onCompleted: { _ in
                print("uploadReviewExecute completed")
            } onDisposed: { _ in
                print("uploadReviewExecute disposed")
            }
            .disposed(by: disposeBag)
    }
    
    func missingField() {
        toastMessage.accept(R.Phrase.missingReviewField)
    }
    
    func registerReviewId(burgerHousePostId: String, reviewId: String) {
        uploadPostUseCase.registerReviewIdExecute(
            query: .init(
                postId: burgerHousePostId,
                reviewId: reviewId
            )
        )
        .asDriver(onErrorJustReturn: .failure(.commentFail(message: R.Phrase.errorOccurred)))
        .drive(with: self) { owner, result in
            switch result {
            case .success(_):
                owner.didSuccessUploadReview.accept(())
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
                        owner.registerReviewId(burgerHousePostId: burgerHousePostId, reviewId: reviewId)
                    }
                case .unknown(let message):
                    owner.toastMessage.accept(message)
                }
            }
        } onCompleted: { _ in
            print("registerReviewIdExecute completed")
        } onDisposed: { _ in
            print("registerReviewIdExecute disposed")
        }
        .disposed(by: disposeBag)
    }
}

extension DefaultWriteReviewViewModel {
    private func refreshAccessToken(completion: @escaping () -> Void) {
        uploadPostUseCase.refreshAccessTokenExecute()
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
