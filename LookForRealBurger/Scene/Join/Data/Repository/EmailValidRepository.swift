//
//  EmailValidRepository.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/19/24.
//

import Foundation
import Moya

protocol EmailValidRepository {
    func emailValidRequest(
        query: EmailQuery,
        completion: @escaping (Result<EmailValidMessage, EmailValidError>) -> Void
    )
}

enum EmailValidError: Error {
    case network(_ message: String)
    case missingFields(_ message: String)
    case enable(_ message: String)
    case unknown(_ message: String)
}

final class DefaultEmailValidRepository {
    private let network: NetworkManager
    
    init(network: NetworkManager) {
        self.network = network
    }
}

extension DefaultEmailValidRepository: EmailValidRepository {
    func emailValidRequest(
        query: EmailQuery,
        completion: @escaping (Result<EmailValidMessage, EmailValidError>) -> Void
    ) {
        let requestDTO = JoinRequestDTO.EmailValidDTO(email: query.email)
        
        network.request(
            LFRBNetworkRouter.emailValid(requestDTO),
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
                case .unknown(let statusCode):
                    switch statusCode {
                    case 400:
                        completion(.failure(.missingFields("이메일을 입력해주세요")))
                        print("JoinRepository 이메일 중복 확인 에러 -> missingFields")
                    case 409:
                        completion(.failure(.enable("사용이 불가한 이메일입니다")))
                        print("JoinRepository 이메일 중복 확인 에러 -> enable")
                    default:
                        completion(.failure(.unknown("알 수 없는 에러 발생")))
                        print("JoinRepository 이메일 중복 확인 에러 -> unknown")
                    }
                }
            }
        }
    }
}
