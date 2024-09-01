//
//  BurgerReviewScene.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/29/24.
//

import Foundation

enum BurgerHouseReviewScene {
    static func makeView(getPostType: GetPostType) -> BurgerHouseReviewViewController {
        let postRepository = DefaultPostRepository.shared
        let authRepository = DefualtAuthRepository.shared
        let burgerReviewUseCase = DefaultBurgerHouseReviewUseCase(
            postRepository: postRepository,
            authRepository: authRepository
        )
        let accessStorage = UserDefaultsAccessStorage.shared
        let viewModel = DefaultBurgerHouseReviewViewModel(
            burgerReviewUseCase: burgerReviewUseCase,
            accessStorage: accessStorage,
            getPostType: getPostType
        )
        let view = BurgerHouseReviewViewController.create(viewModel: viewModel)
        return view
    }
    
    static func makeView(burgerHouseReview: BurgerHouseReview) -> BurgerHouseReviewDetailViewController {
        let postRepository = DefaultPostRepository.shared
        let authRepository = DefualtAuthRepository.shared
        let profileRepository = DefualtProfileRepository.shared
        let likeRepository = DefaultLikeRepository.shared
        let burgerHouseReviewDetailUseCase = DefaultBurgerHouseReviewDetailUseCase(
            postRepository: postRepository,
            authRepository: authRepository,
            profileRepository: profileRepository,
            likeRepository: likeRepository
        )
        let accessStorage = UserDefaultsAccessStorage.shared
        let viewModel = DefaultBurgerHouseReviewDetailViewModel(
            burgerHouseReviewDetailUseCase: burgerHouseReviewDetailUseCase,
            accessStorage: accessStorage,
            burgerHouseReview: burgerHouseReview
        )
        let view = BurgerHouseReviewDetailViewController.create(
            viewModel: viewModel
        )
        return view
    }
    
    static func makeView(
        postId: String,
        comments: [Comment]
    ) -> BurgerHouseReviewCommentViewController {
        let commentRepository = DefaultCommentRepository.shared
        let authRepository = DefualtAuthRepository.shared
        let burgerHouseReviewCommentUseCase = DefaultBurgerHouseReviewCommentUseCase(
            commentRepository: commentRepository,
            authRepository: authRepository
        )
        let accessStorage = UserDefaultsAccessStorage.shared
        let viewModel = DefaultBurgerHouseReviewCommentlViewModel(
            burgerHouseReviewCommentUseCase: burgerHouseReviewCommentUseCase,
            accessStorage: accessStorage,
            postId: postId,
            comments: comments)
        let view = BurgerHouseReviewCommentViewController.create(viewModel: viewModel)
        return view
    }
}
