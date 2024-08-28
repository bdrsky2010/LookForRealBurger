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
    case network(message: String)
    case badRequest(message: String)
    case invalidToken(message: String)
    case forbidden(message: String)
    case expiredToken
    case unknown(message: String)
    
    // 업로드 포스트
    case invalidValue(message: String) // price의 타입이 int가 아닌 경우(빈 문자열 포함)
    case dbServer(message: String) // db서버 장애로 게시글이 저장되지 않았을 때
}

enum PostAPIType: String {
    case uploadImage
    case uploadPost
    case getPost
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
    
    func getPostRequest(
        query: GetPostQuery,
        completion: @escaping (Result<[GetBurgerHouse], PostError>) -> Void
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
            PostRouter.imageUpload(uploadImageRequestDTO),
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
            price: query.totalRating,
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
                completion(.success(success.toDomain()))
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
                completion(.success(success.toDomain()))
            case .failure(let failure):
                let postError = errorHandling(type: .uploadPost, failure: failure)
                completion(.failure(postError))
            }
        }
    }
    
    func getPostRequest(
        query: GetPostQuery,
        completion: @escaping (Result<[GetBurgerHouse], PostError>) -> Void
    ) {
        let getPostRequestDTO = GetPostRequestDTO(
            next: query.next,
            limit: query.limit,
            productId: query.productId
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
}

extension DefaultPostRepository {
    private func errorHandling(type: PostAPIType, failure: NetworkError) -> PostError {
        let postError: PostError
        switch failure {
        case .requestFailure(let error):
            postError = .network(message: R.Phrase.errorOccurred)
            print("PostRepository \(type.rawValue) 에러 -> \(error.localizedDescription)")
        case .apiKey, .invalidData, .tooManyRequest, .invalidURL, .networkFailure:
            postError = .network(message: R.Phrase.errorOccurred)
            print("PostRepository \(type.rawValue) 에러 -> \(failure.self)")
        case .unknown(let statusCode):
            switch statusCode {
            case 400:
                if type == .uploadPost {
                    postError = .invalidValue(message: R.Phrase.errorOccurred)
                } else if type == .uploadPost {
                    postError = .badRequest(message: R.Phrase.errorOccurred)
                } else { // 업로드 이미지
                    postError = .badRequest(message: "이미지 파일에 대한 형식이 맞지 않습니다.")
                }
            case 401:
                postError = .invalidToken(message: R.Phrase.errorOccurred)
            case 403:
                postError = .forbidden(message: R.Phrase.errorOccurred)
            case 410:
                postError = .dbServer(message: "DB서버 장애로 인하여 에러가 발생하였습니다.\n잠시후에 다시 시도 부탁드립니다.")
            case 419:
                postError = .expiredToken
            default:
                postError = .unknown(message: R.Phrase.errorOccurred)
                
            }
        }
        print("PostRepository \(type.rawValue) 에러 -> \(postError)")
        return postError
    }
}
