//
//  LikeRepository.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/27/24.
//

import Foundation

enum LikeError: Error {
    case network(message: String)
    case badRequest(message: String)
    case invalidToken(message: String)
    case forbidden(message: String)
    case notFoundPost(message: String)
    case expiredToken
    case unknown(message: String)
}

enum LikeAPIType: String {
    case like
    case like2
    case myLikePost
}

protocol LikeRepository {
    func likeRequest(
        query: LikeRequestQuery,
        completion: @escaping (Result<GetIsLikePost, LikeError>) -> Void
    )
    
    func bookmarkRequest(
        query: BookmarkRequestQuery,
        completion: @escaping (Result<GetIsBookmarkPost, LikeError>) -> Void
    )
}

final class DefaultLikeRepository {
    static let shared = DefaultLikeRepository()
    
    private let networkManager: NetworkManager
    
    private init(
        networkManager: NetworkManager = LFRBNetworkManager.shared
    ) {
        self.networkManager = networkManager
    }
}

extension DefaultLikeRepository: LikeRepository {
    func likeRequest(
        query: LikeRequestQuery,
        completion: @escaping (Result<GetIsLikePost, LikeError>) -> Void
    ) {
        let requestDTO = LikeRequestDTO(likeStatus: query.likeStatus)
        networkManager.request(
            LikeRouter.like(query.postId, requestDTO),
            of: LikeResponseDTO.self
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                completion(.success(success.toDomain()))
            case .failure(let failure):
                let likeError = errorHandling(type: .like, failure: failure)
                completion(.failure(likeError))
            }
        }
    }
    
    func bookmarkRequest(
        query: BookmarkRequestQuery,
        completion: @escaping (Result<GetIsBookmarkPost, LikeError>) -> Void
    ) {
        let requestDTO = LikeRequestDTO(likeStatus: query.bookmarkStatus)
        networkManager.request(
            LikeRouter.like2(query.postId, requestDTO),
            of: LikeResponseDTO.self
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                completion(.success(success.toDomain()))
            case .failure(let failure):
                let likeError = errorHandling(type: .like2, failure: failure)
                completion(.failure(likeError))
            }
        }
    }
}

extension DefaultLikeRepository {
    private func errorHandling(type: LikeAPIType, failure: NetworkError) -> LikeError {
        let likeError: LikeError
        switch failure {
        case .requestFailure(let error):
            likeError = .network(message: R.Phrase.errorOccurred)
            print("LikeRepository \(type.rawValue) netork 에러 발생 -> \(error)")
        case .apiKey, .invalidData, .tooManyRequest, .invalidURL:
            likeError = .network(message: R.Phrase.errorOccurred)
            print("LikeRepository \(type.rawValue) netork 에러 발생 -> \(failure)")
        case .networkFailure:
            likeError = .network(message: R.Phrase.networkUnstable)
            print("LikeRepository \(type.rawValue) network 에러 발생 -> \(failure)")
        case .unknown(let statusCode):
            switch statusCode {
            case 400:
                likeError = .badRequest(message: R.Phrase.errorOccurred)
            case 401:
                likeError = .invalidToken(message: R.Phrase.errorOccurred)
            case 403:
                likeError = .forbidden(message: R.Phrase.errorOccurred)
            case 410:
                likeError = .notFoundPost(message: R.Phrase.notFoundPost)
            case 419:
                likeError = .expiredToken
            default:
                likeError = .unknown(message: R.Phrase.errorOccurred)
            }
        }
        print("LikeRepository \(type.rawValue) 에러 -> \(likeError)")
        return likeError
    }
}
