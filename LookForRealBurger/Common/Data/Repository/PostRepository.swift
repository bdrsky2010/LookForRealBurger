//
//  PostRepository.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/27/24.
//

import Foundation

enum PostType: String {
    case review
    case burgerHouse
}

enum PostError: Error {
    // 공통
    case network(_ message: String)
    case badRequest(_ message: String)
    case invalidToken(_ message: String)
    case forbidden(_ message: String)
    case expiredToken
    case unknown(_ message: String)
    
    // 업로드 포스트
    case invalidValue(_ message: String) // price의 타입이 int가 아닌 경우(빈 문자열 포함)
    case dbServer(_ message: String) // db서버 장애로 게시글이 저장되지 않았을 때
}

enum PostAPIType: String {
    case uploadImage
    case uploadPost
    case getPost
    case getSinglePost
}

protocol PostRepository {
    func uploadImageRequest(
        files: [Data],
        completion: @escaping (Result<UploadedImage, PostError>) -> Void
    )
    
    func uploadBurgerHouse(
        query: UploadBurgerHouseQuery,
        completion: @escaping (Result<GetBurgerHouse, PostError>) -> Void
    )
    
    func uploadBurgerHouseReview(
        query: UploadBurgerHouseReviewQuery,
        completion: @escaping (Result<BurgerHouseReview, PostError>) -> Void
    )
    
    func getBurgerHouseRequest(
        query: GetPostQuery,
        completion: @escaping (Result<[GetBurgerHouse], PostError>) -> Void
    )
    
    func getBurgerMapHouseRequest(
        query: GetPostQuery,
        completion: @escaping (Result<[BurgerMapHouse], PostError>) -> Void
    )
    
    func getSingleBurgerHouseReviewRequest(
        query: GetSinglePostQuery,
        completion: @escaping (Result<BurgerHouseReview, PostError>) -> Void
    )
    
    func getBurgerHouseReviewRequest(
        query: GetPostQuery,
        completion: @escaping (Result<GetBurgerHouseReview, PostError>) -> Void
    )
}

final class DefaultPostRepository {
    static let shared = DefaultPostRepository()
    
    private let network: NetworkManager
    
    private init(network: NetworkManager = LFRBNetworkManager.shared) {
        self.network = network
    }
}

extension DefaultPostRepository: PostRepository {
    func uploadImageRequest(
        files: [Data],
        completion: @escaping (Result<UploadedImage, PostError>
        ) -> Void) {
        let uploadImageRequestDTO = UploadImageRequestDTO(files: files)
        network.request(
            PostRouter.uploadImage(uploadImageRequestDTO),
            of: UploadImageResponseDTO.self
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                completion(.success(success.toDomain()))
            case .failure(let failure):
                let postError = errorHandling(type: .uploadImage, failure: failure)
                completion(.failure(postError))
            }
        }
    }
    
    func uploadBurgerHouse(
        query: UploadBurgerHouseQuery,
        completion: @escaping (Result<GetBurgerHouse, PostError>) -> Void
    ) {
        let uploadPostRequestDTO = UploadPostRequestDTO(
            title: query.name,
            price: nil,
            content: query.hashtagName,
            content1: query.longitude,
            content2: query.latitude,
            content3: query.roadAddress,
            content4: query.phone,
            content5: query.localId,
            productID: LFRBProductID.burgerHouseTest.rawValue,
            files: nil
        )
        network.request(
            PostRouter.uploadPost(uploadPostRequestDTO),
            of: PostResponseDTO.self
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                completion(.success(success.toBurgerHouse()))
            case .failure(let failure):
                let postError = errorHandling(type: .uploadPost, failure: failure)
                completion(.failure(postError))
            }
        }
    }
    
    func uploadBurgerHouseReview(
        query: UploadBurgerHouseReviewQuery,
        completion: @escaping (Result<BurgerHouseReview, PostError>
        ) -> Void) {
        let uploadPostRequestDTO = UploadPostRequestDTO(
            title: query.title,
            price: query.rating,
            content: query.content,
            content1: query.burgerHousePostId,
            content2: nil,
            content3: nil,
            content4: nil,
            content5: nil,
            productID: LFRBProductID.reviewTest.rawValue,
            files: query.files
        )
        network.request(
            PostRouter.uploadPost(uploadPostRequestDTO),
            of: PostResponseDTO.self
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                completion(.success(success.toBurgerHouseReview()))
            case .failure(let failure):
                let postError = errorHandling(type: .uploadPost, failure: failure)
                completion(.failure(postError))
            }
        }
    }
    
    func getBurgerHouseRequest(
        query: GetPostQuery,
        completion: @escaping (Result<[GetBurgerHouse], PostError>) -> Void
    ) {
        let getPostRequestDTO = GetPostRequestDTO(
            next: query.next,
            limit: query.limit,
            productId: LFRBProductID.reviewTest.rawValue
        )
        network.request(
            PostRouter.getPost(getPostRequestDTO),
            of: GetPostResponseDTO.self) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let success):
                    completion(.success(success.toDomain()))
                case .failure(let failure):
                    let postError = errorHandling(type: .getPost, failure: failure)
                    completion(.failure(postError))
                }
            }
    }
    
    func getBurgerMapHouseRequest(
        query: GetPostQuery,
        completion: @escaping (Result<[BurgerMapHouse], PostError>) -> Void
    ) {
        let getPostRequestDTO = GetPostRequestDTO(
            next: query.next,
            limit: query.limit,
            productId: LFRBProductID.burgerHouseTest.rawValue
        )
        network.request(
            PostRouter.getPost(getPostRequestDTO),
            of: GetPostResponseDTO.self) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let success):
                    completion(.success(success.toDomain()))
                case .failure(let failure):
                    let postError = errorHandling(type: .getPost, failure: failure)
                    completion(.failure(postError))
                }
            }
    }
    
    func getSingleBurgerHouseReviewRequest(
        query: GetSinglePostQuery,
        completion: @escaping (Result<BurgerHouseReview, PostError>) -> Void
    ) {
        network.request(
            PostRouter.getSinglePost(query.postId),
            of: PostResponseDTO.self
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                completion(.success(success.toBurgerHouseReview()))
            case .failure(let failure):
                let postError = errorHandling(type: .getSinglePost, failure: failure)
                completion(.failure(postError))
            }
        }
    }
    
    func getBurgerHouseReviewRequest(
        query: GetPostQuery,
        completion: @escaping (Result<GetBurgerHouseReview, PostError>) -> Void
    ) {
        let getPostRequestDTO: GetPostRequestDTO
        let router: LFRBTargetType
        switch query.type {
        case .total:
            getPostRequestDTO = .init(next: query.next, limit: query.limit, productId: LFRBProductID.reviewTest.rawValue)
            router = PostRouter.getPost(getPostRequestDTO)
        case .byUser(let userId):
            getPostRequestDTO = .init(next: query.next, limit: query.limit, productId: LFRBProductID.reviewTest.rawValue)
            router = PostRouter.byUserPost(userId, getPostRequestDTO)
        case .myLike:
            getPostRequestDTO = .init(next: query.next, limit: query.limit, productId: nil)
            router = LikeRouter.myLikePost(getPostRequestDTO)
        case .myLike2:
            getPostRequestDTO = .init(next: query.next, limit: query.limit, productId: nil)
            router = LikeRouter.myLikePost2(getPostRequestDTO)
        }
        network.request(
            router,
            of: GetPostResponseDTO.self
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                completion(.success(success.toDomain()))
            case .failure(let failure):
                let postError = errorHandling(type: .getPost, failure: failure)
                completion(.failure(postError))
            }
        }
    }
}

extension DefaultPostRepository {
    private func errorHandling(type: PostAPIType, failure: NetworkError) -> PostError {
        let postError: PostError
        switch failure {
        case .requestFailure(let error):
            postError = .network(R.Phrase.errorOccurred)
            print("PostRepository \(type.rawValue) 에러 -> \(error.localizedDescription)")
        case .apiKey, .invalidData, .tooManyRequest, .invalidURL, .networkFailure:
            postError = .network(R.Phrase.errorOccurred)
            print("PostRepository \(type.rawValue) 에러 -> \(failure.self)")
        case .unknown(let statusCode):
            switch statusCode {
            case 400:
                if type == .uploadPost {
                    postError = .invalidValue(R.Phrase.errorOccurred)
                } else if type == .uploadPost {
                    postError = .badRequest(R.Phrase.errorOccurred)
                } else { // 업로드 이미지
                    postError = .badRequest("이미지 파일에 대한 형식이 맞지 않습니다.")
                }
            case 401:
                postError = .invalidToken(R.Phrase.errorOccurred)
            case 403:
                postError = .forbidden(R.Phrase.errorOccurred)
            case 410:
                postError = .dbServer("DB서버 장애로 인하여 에러가 발생하였습니다.\n잠시후에 다시 시도 부탁드립니다.")
            case 419:
                postError = .expiredToken
            default:
                postError = .unknown(R.Phrase.errorOccurred)
                
            }
        }
        print("PostRepository \(type.rawValue) 에러 -> \(postError)")
        return postError
    }
}
