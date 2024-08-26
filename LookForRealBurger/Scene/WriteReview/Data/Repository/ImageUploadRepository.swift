//
//  ImageUploadRepository.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/26/24.
//

import Foundation

enum ImageUploadError: Error {
    case network(message: String)
    case badRequest(message: String)
    case invalidToken(message: String)
    case forbidden(message: String)
    case expiredToken
    case unknown(message: String)
}

protocol ImageUploadRepository {
    func uploadRequest(
        files: [Data],
        completion: @escaping (Result<UploadedImage, ImageUploadError>) -> Void
    )
}

final class DefaultImageUploadRepository {
    private let network: NetworkManager
    
    init(network: NetworkManager) {
        self.network = network
    }
}

extension DefaultImageUploadRepository: ImageUploadRepository {
    func uploadRequest(
        files: [Data],
        completion: @escaping (Result<UploadedImage, ImageUploadError>
        ) -> Void) {
        network.request(
            LFRBNetworkRouter.imageUpload(files),
            of: ImageUploadResponseDTO.self
        ) { result in
            switch result {
            case .success(let success):
                completion(.success(success.toDomain()))
            case .failure(let failure):
                switch failure {
                case .requestFailure(let error):
                    completion(.failure(.network(message: "에러가 발생하였습니다.\n잠시후에 다시 시도 부탁드립니다.")))
                    print("ImageUploadRepository 이미지 업로드 에러 -> \(error.localizedDescription)")
                case .apiKey, .invalidData, .tooManyRequest, .invalidURL, .networkFailure:
                    completion(.failure(.network(message: "에러가 발생하였습니다.\n잠시후에 다시 시도 부탁드립니다.")))
                    print("ImageUploadRepository 이미지 업로드 에러 -> \(failure.self)")
                case .unknown(let statusCode):
                    switch statusCode {
                    case 400:
                        completion(.failure(.badRequest(message: "이미지 파일에 대한 형식이 맞지 않습니다.")))
                        print("ImageUploadRepository 이미지 업로드 에러 -> Bad Request Or MissingFields")
                    case 401:
                        completion(.failure(.invalidToken(message: "에러가 발생하였습니다.\n잠시후에 다시 시도 부탁드립니다.")))
                        print("ImageUploadRepository 이미지 업로드 에러 -> Invalid Access Token")
                    case 403:
                        completion(.failure(.forbidden(message: "에러가 발생하였습니다.\n잠시후에 다시 시도 부탁드립니다.")))
                        print("ImageUploadRepository 이미지 업로드 에러 -> Forbidden")
                    case 419:
                        completion(.failure(.expiredToken))
                        print("ImageUploadRepository 이미지 업로드 에러 -> Access Token 만료")
                    default:
                        completion(.failure(.unknown(message: "에러가 발생하였습니다.\n잠시후에 다시 시도 부탁드립니다.")))
                        print("ImageUploadRepository 이미지 업로드 에러 -> unknown")
                    }
                }
            }
        }
    }
}
