//
//  CommentRepository.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/27/24.
//

import Foundation

enum CommentError: Error {
    case network(message: String)
    case missingData(message: String)
    case invalidToken(message: String)
    case forbidden(message: String)
    case commentFail(message: String)
    case expiredToken
    case unknown(message: String)
}

enum CommentAPIType: String {
    case writeComment
    case deleteComment
}

protocol CommentRepository {
    func registerReviewIdRequest(
        query: RegisterReviewIdQuery,
        completion: @escaping (Result<RegisteredReview, CommentError>) -> Void
    )
    
    func writeCommentRequest(
        query: WriteCommentQuery,
        completion: @escaping (Result<Comment, CommentError>) -> Void
    )
}

final class DefaultCommentRepository {
    static let shared = DefaultCommentRepository()
    
    private let networkManager: NetworkManager
    
    private init(
        networkManager: NetworkManager = LFRBNetworkManager.shared
    ) {
        self.networkManager = networkManager
    }
}

extension DefaultCommentRepository: CommentRepository {
    func registerReviewIdRequest(
        query: RegisterReviewIdQuery,
        completion: @escaping (Result<RegisteredReview, CommentError>) -> Void
    ) {
        let requestDTO = CommentRequestDTO(content: query.reviewId)
        networkManager.request(
            CommentRouter.comment(query.postId, requestDTO),
            of: CommentResponseDTO.self
        ) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let success):
                    completion(.success(success.toDomain()))
                case .failure(let failure):
                    let commentError = errorHandling(type: .writeComment, failure: failure)
                    completion(.failure(commentError))
                }
            }
    }
    
    func writeCommentRequest(
        query: WriteCommentQuery,
        completion: @escaping (Result<Comment, CommentError>) -> Void
    ) {
        let requestDTO = CommentRequestDTO(content: query.content)
        networkManager.request(
            CommentRouter.comment(query.postId, requestDTO),
            of: CommentResponseDTO.self
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                completion(.success(success.toDomain()))
            case .failure(let failure):
                let commentError = errorHandling(type: .writeComment, failure: failure)
                completion(.failure(commentError))
            }
        }
    }
}

extension DefaultCommentRepository {
    private func errorHandling(
        type: CommentAPIType,
        failure: NetworkError
    ) -> CommentError {
        let commentError: CommentError
        switch failure {
        case .requestFailure(let error):
            commentError = .network(message: R.Phrase.errorOccurred)
            print("CommentRepository \(type.rawValue) network 에러 발생 -> \(error)")
        case .apiKey, .invalidData, .tooManyRequest, .invalidURL:
            commentError = .network(message: R.Phrase.errorOccurred)
            print("CommentRepository \(type.rawValue) network 에러 발생 -> \(failure)")
        case .networkFailure:
            commentError = .network(message: R.Phrase.networkUnstable)
            print("CommentRepository \(type.rawValue) network 에러 발생 -> \(failure)")
        case .unknown(let statusCode):
            switch statusCode {
            case 400:
                commentError = .missingData(message: R.Phrase.errorOccurred)
            case 401:
                commentError = .invalidToken(message: R.Phrase.errorOccurred)
            case 403:
                commentError = .forbidden(message: R.Phrase.errorOccurred)
            case 410:
                commentError = .commentFail(message: R.Phrase.errorOccurred)
            case 419:
                commentError = .expiredToken
            default:
                commentError = .unknown(message: R.Phrase.errorOccurred)
            }
        }
        print("CommentRepository \(type.rawValue) 에러 -> \(commentError)")
        return commentError
    }
}
