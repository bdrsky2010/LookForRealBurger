//
//  EmailValidRepository.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/19/24.
//

import Foundation
import Moya

enum EmailValidError: Error {
    case network(_ message: String)
    case missingFields(_ message: String)
    case enable(_ message: String)
    case unknown(_ message: String)
}

final class EmailValidRepository {
    private let network: LFRBNetworkManager
    
    init(network: LFRBNetworkManager = LFRBNetworkManager.shared) {
        self.network = network
    }
    
    func emailValidRequest(
        query: EmailQuery,
        completion: @escaping (Result<EmailValidMessage, EmailValidError>) -> Void
    ) {
        let requestDTO = JoinRequestDTO.EmailValidDTO(email: query.email)
        
        network.request(
            JoinRouter.emailValid(requestDTO),
            of: JoinResponseDTO.EmailValidDTO.self
        ) { result in
            switch result {
            case .success(let success):
                completion(.success(success.toDomain()))
            case .failure(let failure):
                switch failure {
                case .requestFailure(let error):
                    completion(.failure(.network(R.Phrase.errorOccurred)))
                    print("JoinRepository 네트워크 에러 -> \(failure.self)")
                    print(error.localizedDescription)
                case .apiKey, .invalidData, .tooManyRequest, .invalidURL:
                    completion(.failure(.network(R.Phrase.errorOccurred)))
                    print("JoinRepository 네트워크 에러 -> \(failure.self)")
                case .networkFailure:
                    completion(.failure(.network(R.Phrase.networkUnstable)))
                    print("JoinRepository 네트워크 에러 -> networkFailure")
                case .unknown(let statusCode, let description):
                    switch statusCode {
                    case 400:
                        completion(.failure(.missingFields(description)))
                        print("JoinRepository 이메일 중복 확인 에러 -> missingFields")
                    case 409:
                        completion(.failure(.enable(description)))
                        print("JoinRepository 이메일 중복 확인 에러 -> enable")
                    default:
                        completion(.failure(.unknown(description)))
                        print("JoinRepository 이메일 중복 확인 에러 -> unknown")
                    }
                }
            }
        }
    }
}
