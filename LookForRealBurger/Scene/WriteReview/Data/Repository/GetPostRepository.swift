//
//  GetPostRepository.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/26/24.
//

import Foundation

enum PostType: String {
    case review
    case burgerHouse
}

enum GetPostError: Error {
    case network(message: String)
    case badRequest(message: String)
    case invalidToken(message: String)
    case forbidden(message: String)
    case expiredToken
    case unknown(message: String)
}

protocol GetPostRepository {
    func getPostRequest(
        query: GetPostQuery,
        completion: @escaping (Result<[GetBurgerHouse], GetPostError>) -> Void
    )
}

final class DefaultGetPostRepository {
    private let network: NetworkManager
    
    init(network: NetworkManager) {
        self.network = network
    }
}

extension DefaultGetPostRepository: GetPostRepository {
    func getPostRequest(
        query: GetPostQuery,
        completion: @escaping (Result<[GetBurgerHouse], GetPostError>) -> Void
    ) {
        let getPostRequestDTO = GetPostRequestDTO(
            next: query.next,
            limit: query.limit,
            productId: query.productId
        )
        
        network.request(
            LFRBNetworkRouter.getPost(getPostRequestDTO),
            of: GetPostResponseDTO.self) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let success):
                    completion(.success(success.toDomain()))
                case .failure(let failure):
                    let getPostError = getPostErrorHandling(type: .burgerHouse, failure: failure)
                    completion(.failure(getPostError))
                }
            }
    }
}

extension DefaultGetPostRepository {
    private func getPostErrorHandling(
        type: PostType,
        failure: NetworkError
    ) -> GetPostError {
        let sendError: GetPostError
        switch failure {
        case .requestFailure(let error):
            sendError = .network(message: "에러가 발생하였습니다.\n잠시후에 다시 시도 부탁드립니다.")
            print("GetPostRepository(\(type.rawValue)) 포스트 조회 에러 -> \(error.localizedDescription)")
        case .apiKey, .invalidData, .tooManyRequest, .invalidURL, .networkFailure:
            sendError = .network(message: "에러가 발생하였습니다.\n잠시후에 다시 시도 부탁드립니다.")
            print("GetPostRepository(\(type.rawValue)) 포스트 조회 에러 -> \(failure.self)")
        case .unknown(let statusCode):
            switch statusCode {
            case 400:
                sendError = .badRequest(message: "이미지 파일에 대한 형식이 맞지 않습니다.")
                print("GetPostRepository(\(type.rawValue)) 포스트 조회 에러 -> Bad Request")
            case 401:
                sendError = .invalidToken(message: "에러가 발생하였습니다.\n잠시후에 다시 시도 부탁드립니다.")
                print("GetPostRepository(\(type.rawValue)) 포스트 조회 에러 -> Invalid Access Token")
            case 403:
                sendError = .forbidden(message: "에러가 발생하였습니다.\n잠시후에 다시 시도 부탁드립니다.")
                print("GetPostRepository(\(type.rawValue)) 포스트 조회 에러 -> Forbidden")
            case 419:
                sendError = .expiredToken
                print("GetPostRepository(\(type.rawValue)) 포스트 조회 에러 -> Access Token 만료")
            default:
                sendError = .unknown(message: "에러가 발생하였습니다.\n잠시후에 다시 시도 부탁드립니다.")
                print("GetPostRepository(\(type.rawValue)) 포스트 조회 에러 -> unknown")
            }
        }
        return sendError
    }
}
