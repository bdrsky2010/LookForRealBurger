//
//  AuthRepository.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/27/24.
//

import Foundation

enum AuthError: Error {
    // 공통
    case network(_ message: String)
    case missingFields(_ message: String)
    case accountVerify(_ message: String)
    case invalidToken(_ message: String)
    case forbidden(_ message: String)
    case unknown(_ message: String)
    
    // 회원가입
    case existBlank(_ message: String)
    case existUser(_ message: String)
    
    // 이메일 중복확인
    case enable(_ message: String)
    
    // AccessToken 갱신
    case expiredRefreshToken
    
    // 탈퇴
    case expiredAccessToken
}

enum AuthAPIType: String {
    case join
    case emailValidation
    case login
    case accessTokenRefresh
    case withdraw
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
    
    func refreshAccessToken(
        completion: @escaping (Result<AccessToken, AuthError>) -> Void
    )
}

final class DefualtAuthRepository {
    static let shared = DefualtAuthRepository()
    
    private let network: NetworkManager
    
    private init(
        network: NetworkManager = LFRBNetworkManager.shared
    ) {
        self.network = network
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
            AuthRouter.join(requestDTO),
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
            AuthRouter.emailValid(requestDTO),
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
            AuthRouter.login(requestDTO),
            of: LoginResponseDTO.self
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                completion(.success(success.toDomain()))
            case .failure(let failure):
                let authError = errorHandling(type: .login, failure: failure)
                completion(.failure(authError))
            }
        }
    }
    
    func refreshAccessToken(
        completion: @escaping (Result<AccessToken, AuthError>) -> Void
    ) {
        network.request(
            AuthRouter.accessTokenRefresh,
            of: RefreshAccessTokenResponseDTO.self
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                completion(.success(success.toDomain()))
            case .failure(let failure):
                let authError = errorHandling(type: .accessTokenRefresh, failure: failure)
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
            authError = .network(R.Phrase.errorOccurred)
            print("AuthRepository \(type.rawValue) network 에러 발생 -> \(error)")
        case .apiKey, .invalidData, .tooManyRequest, .invalidURL:
            authError = .network(R.Phrase.errorOccurred)
            print("AuthRepository \(type.rawValue) network 에러 발생 -> \(failure)")
        case .networkFailure:
            authError = .network(R.Phrase.networkUnstable)
            print("AuthRepository \(type.rawValue) network 에러 발생 -> \(failure)")
        case .unknown(let statusCode):
            switch statusCode {
            case 400:
                authError = .missingFields(R.Phrase.missingFieldError)
            case 401:
                if type == .accessTokenRefresh {
                    authError = .invalidToken(R.Phrase.errorOccurred)
                } else { // 로그인
                    authError = .accountVerify(R.Phrase.accountVerifyError)
                }
            case 402:
                authError = .existBlank(R.Phrase.existBlankNick)
            case 403:
                authError = .forbidden(R.Phrase.errorOccurred)
            case 409:
                if type == .join {
                    authError = .existUser(R.Phrase.alreadyAccount)
                } else {
                    authError = .enable(R.Phrase.alreadyAccount)
                }
            case 418:
                authError = .expiredRefreshToken
            case 419:
                authError = .expiredAccessToken
            default:
                authError = .unknown(R.Phrase.errorOccurred)
            }
        }
        print("AuthRepository \(type.rawValue) 에러 -> \(authError)")
        return authError
    }
}
