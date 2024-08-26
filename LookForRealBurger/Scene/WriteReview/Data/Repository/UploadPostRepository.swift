//
//  PostUploadRepository.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/26/24.
//

import Foundation

enum UploadPostError: Error {
    case network(message: String)
    case invalidValue(message: String) // price의 타입이 int가 아닌 경우(빈 문자열 포함)
    case invalidToken(message: String)
    case forbidden(message: String)
    case dbServer(message: String) // db서버 장애로 게시글이 저장되지 않았을 때
    case expiredToken
    case unknown(message: String)
}

protocol UploadPostRepository {
    func uploadBurgerHouse(
        query: UploadBurgerHouseQuery,
        completion: @escaping (Result<GetBurgerHouse, UploadPostError>) -> Void
    )
}

final class DefaultUploadPostRepository {
    private let network: NetworkManager
    
    init(network: NetworkManager) {
        self.network = network
    }
}

extension DefaultUploadPostRepository: UploadPostRepository {
    func uploadBurgerHouse(
        query: UploadBurgerHouseQuery,
        completion: @escaping (Result<GetBurgerHouse, UploadPostError>) -> Void
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
            productID: LFRBProductID.burgerHouse.rawValue,
            files: nil
        )
        network.request(
            LFRBNetworkRouter.uploadPost(uploadPostRequestDTO),
            of: PostResponseDTO.self
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                completion(.success(success.toDomain()))
            case .failure(let failure):
                let uploadPostError = uploadPostErrorHandling(type: .burgerHouse, failure: failure)
                completion(.failure(uploadPostError))
            }
        }
    }
}

extension DefaultUploadPostRepository {
    private func uploadPostErrorHandling(
        type: PostType,
        failure: NetworkError
    ) -> UploadPostError {
        let sendError: UploadPostError
        switch failure {
        case .requestFailure(let error):
            sendError = .network(message: "에러가 발생하였습니다.\n잠시후에 다시 시도 부탁드립니다.")
            print("UploadPostRepository(\(type.rawValue)) 포스트 업로드 에러 -> \(error.localizedDescription)")
        case .apiKey, .invalidData, .tooManyRequest, .invalidURL, .networkFailure:
            sendError = .network(message: "에러가 발생하였습니다.\n잠시후에 다시 시도 부탁드립니다.")
            print("UploadPostRepository(\(type.rawValue)) 포스트 업로드 에러 -> \(failure.self)")
        case .unknown(let statusCode):
            switch statusCode {
            case 400:
                sendError = .invalidValue(message: "에러가 발생하였습니다.\n잠시후에 다시 시도 부탁드립니다.")
                print("UploadPostRepository(\(type.rawValue)) 포스트 업로드 에러 -> ")
            case 401:
                sendError = .invalidToken(message: "에러가 발생하였습니다.\n잠시후에 다시 시도 부탁드립니다.")
                print("UploadPostRepository(\(type.rawValue)) 포스트 업로드 에러 -> ")
            case 403:
                sendError = .forbidden(message: "에러가 발생하였습니다.\n잠시후에 다시 시도 부탁드립니다.")
                print("UploadPostRepository(\(type.rawValue)) 포스트 업로드 에러 -> ")
            case 410:
                sendError = .dbServer(message: "DB서버 장애로 인하여 에러가 발생하였습니다.\n잠시후에 다시 시도 부탁드립니다.")
                print("UploadPostRepository(\(type.rawValue)) 포스트 업로드 에러 -> ")
            case 419:
                sendError = .expiredToken
                print("UploadPostRepository(\(type.rawValue)) 포스트 업로드 에러 -> ")
            default:
                sendError = .unknown(message: "에러가 발생하였습니다.\n잠시후에 다시 시도 부탁드립니다.")
                print("UploadPostRepository(\(type.rawValue)) 포스트 업로드 에러 -> ")
            }
        }
        return sendError
    }
}
