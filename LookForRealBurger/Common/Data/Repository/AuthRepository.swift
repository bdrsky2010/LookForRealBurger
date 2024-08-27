//
//  AuthRepository.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/27/24.
//

import Foundation

enum AuthError: Error {
    // 공통
    case network(message: String)
    case missingFields(message: String)
    case accountVerify(message: String)
    case unknown(message: String)
    
    // 회원가입
    case existBlank(_ message: String)
    case existUser(_ message: String)
    
    // 이메일 중복확인
    case enable(_ message: String)
}

enum AuthAPIType: String {
    case join
    case emailValidation
    case login
}

protocol AuthRepository {
    func joinRequest(
        query: JoinQuery,
        completion: @escaping (Result<JoinUser, AuthError>) -> Void
    )
    
    func emailValidRequest(
        query: EmailQuery,
        completion: @escaping (Result<EmailValidMessage, AuthError>) -> Void
    )
    
    func loginRequest(
        query: LoginQuery,
        completion: @escaping (Result<LoginUser, AuthError>) -> Void
    )
}

final class DefualtAuthRepository {
    static let shared = DefualtAuthRepository()
    
    private let network: NetworkManager
    private let accessStorage: AccessStorage
    
    private init(
        network: NetworkManager = LFRBNetworkManager.shared,
        accessStorage: AccessStorage = UserDefaultsAccessStorage.shared
    ) {
        self.network = network
        self.accessStorage = accessStorage
    }
}

extension DefualtAuthRepository: AuthRepository {
    func joinRequest(
        query: JoinQuery,
        completion: @escaping (Result<JoinUser, AuthError>) -> Void
    ) {
        let requestDTO = JoinRequestDTO(
            email: query.email,
            password: query.password,
            nick: query.nick,
            phoneNum: nil,
            birthDay: nil
        )
        
        network.request(
            LFRBNetworkRouter.join(requestDTO),
            of: JoinResponseDTO.self
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                completion(.success(success.toDomain()))
            case .failure(let failure):
                let authError = errorHandling(type: .join, failure: failure)
                completion(.failure(authError))
            }
        }
    }
    
    func emailValidRequest(
        query: EmailQuery,
        completion: @escaping (Result<EmailValidMessage, AuthError>) -> Void
    ) {
        let requestDTO = EmailValidRequestDTO(email: query.email)
        
        network.request(
            LFRBNetworkRouter.emailValid(requestDTO),
            of: EmailValidResponseDTO.self
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                completion(.success(success.toDomain()))
            case .failure(let failure):
                let authError = errorHandling(type: .emailValidation, failure: failure)
                completion(.failure(authError))
            }
        }
    }
    
    func loginRequest(
        query: LoginQuery,
        completion: @escaping (Result<LoginUser, AuthError>
        ) -> Void) {
        let requestDTO = LoginRequestDTO(
            email: query.email,
            password: query.password
        )
        
        network.request(
            LFRBNetworkRouter.login(requestDTO),
            of: LoginResponseDTO.self
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                accessStorage.accessToken = success.accessToken
                accessStorage.refreshToken = success.refreshToken
                accessStorage.accessEmail = query.email
                accessStorage.accessPassword = query.password
                completion(.success(success.toDomain()))
            case .failure(let failure):
                let authError = errorHandling(type: .login, failure: failure)
                completion(.failure(authError))
            }
        }
    }
}

extension DefualtAuthRepository {
    private func errorHandling(
        type: AuthAPIType,
        failure: NetworkError
    ) -> AuthError {
        let authError: AuthError
        switch failure {
        case .requestFailure(let error):
            authError = .network(message: R.Phrase.errorOccurred)
            print("CommentRepository \(type.rawValue) network 에러 발생 -> \(error)")
        case .apiKey, .invalidData, .tooManyRequest, .invalidURL:
            authError = .network(message: R.Phrase.errorOccurred)
            print("CommentRepository \(type.rawValue) network 에러 발생 -> \(failure)")
        case .networkFailure:
            authError = .network(message: R.Phrase.networkUnstable)
            print("CommentRepository \(type.rawValue) network 에러 발생 -> \(failure)")
        case .unknown(let statusCode):
            switch statusCode {
            case 400:
                authError = .missingFields(message: "입력칸을 채워주세요")
            case 401:
                authError = .accountVerify(message: "계정을 다시 확인해주세요")
            case 402:
                authError = .existBlank("공백이 포함된 닉네임은\n사용할 수 없습니다")
            case 409:
                if type == .join {
                    authError = .existUser("이미 가입된 계정입니다")
                } else {
                    authError = .enable("이미 가입된 계정입니다")
                }
            default:
                authError = .unknown(message: "알 수 없는 에러 발생")
            }
        }
        print("AuthRepository \(type.rawValue) 에러 -> \(authError)")
        return authError
    }
}
