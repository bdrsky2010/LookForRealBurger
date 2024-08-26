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
    func confirmedSave(files: [Data])
    func imageUploadSuccess(uploadedImage: UploadedImage)
    func plusRatingTap()
    func minusRatingTap()
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
    var uploadSuccess: PublishRelay<UploadedImage> { get }
}

typealias WriteReviewViewModel = WriteReviewInput & WriteReviewOutput

final class DefaultWriteReviewViewModel: WriteReviewOutput {
    var goToPreviousTab = PublishRelay<Void>()
    var goToLocalSearch = PublishRelay<Void>()
    var selectedBurgerHouse = PublishRelay<String>()
    var presentAddPhotoAction = PublishRelay<Void>()
    var presentCamera = PublishRelay<Void>()
    var presentGallery = PublishRelay<Void>()
    var burgerHouseRating = BehaviorSubject<Int>(value: 1)
    var toastMessage = PublishRelay<String>()
    var saveConfirm = PublishRelay<Void>()
    var uploadSuccess = PublishRelay<UploadedImage>()
    
    private var burgerHouse: BurgerHouse?
    private var loginUseCase: LoginUseCase!
    private var postUploadUseCase: PostUploadUseCase!
    private var disposeBag: DisposeBag!
    
    init(
        loginUseCase: LoginUseCase,
        postUploadUseCase: PostUploadUseCase,
        disposeBag: DisposeBag = DisposeBag()
    ) {
        self.loginUseCase = loginUseCase
        self.postUploadUseCase = postUploadUseCase
        self.disposeBag = disposeBag
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
    
    func confirmedSave(files: [Data]) {
        guard files.reduce(0, { $0 + $1.count }) < 5000000 else {
            toastMessage.accept("사진 용량 제한: 5MB 제한")
            return
        }
        
        postUploadUseCase.uploadImage(files: files)
            .asDriver(onErrorJustReturn: .failure(.unknown(message: R.Phrase.errorOccurred)))
            .drive(with: self) { owner, result in
                switch result {
                case .success(let value):
                    owner.imageUploadSuccess(uploadedImage: value)
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
                        // TODO: 토큰 리프레시
                        print("토큰 리프레시 필요")
                    case .unknown(let message):
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
    
    func imageUploadSuccess(uploadedImage: UploadedImage) {
        print(#function, uploadedImage)
    }
}
