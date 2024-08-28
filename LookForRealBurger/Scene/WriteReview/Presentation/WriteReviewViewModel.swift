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
    func uploadImageSuccess(uploadedImage: UploadedImage)
    func plusRatingTap()
    func minusRatingTap()
    func uploadPost(title: String, content: String, files: UploadedImage)
    func missingField()
    func registerReviewId(burgerHousePostId: String, reviewId: String)
    func refreshAccessToken(completion: @escaping () -> Void)
}

protocol WriteReviewOutput {
    var goToPreviousTab: PublishRelay<Void> { get }
    var goToLocalSearch: PublishRelay<Void> { get }
    var selectedBurgerHouse: PublishRelay<String> { get }
    var presentAddPhotoAction: PublishRelay<Void> { get }
    var presentCamera: PublishRelay<Void> { get }
    var presentGallery: PublishRelay<Void> { get }
    var burgerHouseRating: BehaviorSubject<Int> { get }
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
    var burgerHouseRating = BehaviorSubject<Int>(value: 5)
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
            toastMessage.accept("1장 이상의 사진이 필요합니다")
            return
        }
        guard files.reduce(0, { $0 + $1.count }) < 5000000 else {
            toastMessage.accept("사진 용량 제한: 5MB 제한")
            return
        }
        
        uploadPostUseCase.uploadImageExecute(files: files)
            .asDriver(onErrorJustReturn: .failure(.unknown(message: R.Phrase.errorOccurred)))
            .drive(with: self) { owner, result in
                switch result {
                case .success(let value):
                    print("이미지 업로드 성공")
                    owner.uploadImageSuccess(uploadedImage: value)
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
        do {
            var rating = try burgerHouseRating.value()
            rating = rating < 5 ? (rating + 1) : rating
            burgerHouseRating.onNext(rating)
        } catch {
            toastMessage.accept("왜 여기서 에러가...?")
        }
    }
    
    func minusRatingTap() {
        do {
            var rating = try burgerHouseRating.value()
            rating = rating > 1 ? (rating - 1) : rating
            burgerHouseRating.onNext(rating)
        } catch {
            toastMessage.accept("왜 여기서 에러가...?")
        }
    }
    
    func uploadImageSuccess(uploadedImage: UploadedImage) {
        uploadImageSuccess.accept(uploadedImage)
    }
    
    func uploadPost(title: String, content: String, files: UploadedImage) {
        guard let burgerHouseId = burgerHouse?.burgerHousePostId else {
            toastMessage.accept("햄버거집을 선택해주세요.")
            return
        }
        do {
            let rating = try burgerHouseRating.value()
            let uploadPostQuery = UploadBurgerHouseReviewQuery(
                title: title,
                rating: rating,
                content: content,
                burgerHousePostId: burgerHouseId,
                files: files.paths)
            
            uploadPostUseCase.uploadReviewExecute(query: uploadPostQuery)
                .asDriver(onErrorJustReturn: .failure(.unknown(message: R.Phrase.errorOccurred)))
                .drive(with: self) { owner, result in
                    switch result {
                    case .success(let value):
                        print("리뷰 남기기 성공")
                        owner.registerReviewId(
                            burgerHousePostId: value.burgerHousePostId,
                            reviewId: value.reviewId
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
        } catch {
            toastMessage.accept("왜 여기서 에러가...?")
        }
    }
    
    func missingField() {
        toastMessage.accept("리뷰 항목을 모두 작성해주세요.")
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
            case .success(let value):
                print("햄버거 식당에 리뷰 id 등록 성공적")
                dump(value)
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
    
    func refreshAccessToken(completion: @escaping () -> Void) {
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
