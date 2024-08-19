//
//  JoinRepository.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/19/24.
//

import Foundation
import Moya

enum JoinError: Error {
    case network(_ message: String)
    case missingFields(_ message: String)
    case existUser(_ message: String)
    case unknown(_ message: String)
}

final class JoinRepository {
    private let network: LFRBNetworkManager
    
    init(network: LFRBNetworkManager = LFRBNetworkManager.shared) {
        self.network = network
    }
    
    func joinRequest(
        query: JoinQuery,
        completion: @escaping (Result<JoinUser, JoinError>) -> Void
    ) {
        let requestDTO = JoinRequestDTO.JoinDTO(
            email: query.email,
            password: query.password,
            nick: query.email,
            phoneNum: nil,
            birthDay: nil
        )
        
        network.request(
            JoinRouter.join(requestDTO),
            of: JoinResponseDTO.JoinDTO.self
        ) { result in
            switch result {
            case .success(let success):
                completion(.success(success.toDomain()))
            case .failure(let failure):
                switch failure {
                case .requestFailure(let error):
                    completion(.failure(.network("에러가 발생하였습니다")))
                    print("JoinRepository 네트워크 에러 -> \(failure.self)")
                    print(error.localizedDescription)
                case .apiKey, .invalidData, .tooManyRequest, .invalidURL:
                    completion(.failure(.network("에러가 발생하였습니다")))
                    print("JoinRepository 네트워크 에러 -> \(failure.self)")
                case .networkFailure:
                    completion(.failure(.network("인터넷 연결이 불안정합니다")))
                    print("JoinRepository 네트워크 에러 -> networkFailure")
                case .unknown(let statusCode, let description):
                    switch statusCode {
                    case 400:
                        completion(.failure(.missingFields(description)))
                        print("JoinRepository 회원가입 에러 -> missingFields")
                    case 409:
                        completion(.failure(.existUser(description)))
                        print("JoinRepository 회원가입 에러 -> existUser")
                    default:
                        completion(.failure(.unknown(description)))
                        print("JoinRepository 회원가입 에러 -> unknown")
                    }
                }
            }
        }
    }
}
