//
//  LoginService.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/21/24.
//

import Foundation

protocol LoginService {
    func loginRequest(
        query: LoginQuery,
        completion: @escaping (Result<LoginUser, LoginError>) -> Void
    )
}

enum LoginError: Error {
    case network(_ message: String)
    case missingFields(_ message: String)
    case accountVerify(_ message: String)
    case unknown(_ message: String)
}

final class DefaultLoginService {
    private let network: NetworkManager
    private let tokenStorage: AccessTokenStorage
    
    init(
        network: NetworkManager,
        tokenStorage: AccessTokenStorage
    ) {
        self.network = network
        self.tokenStorage = tokenStorage
    }
}

extension DefaultLoginService: LoginService {
    func loginRequest(
        query: LoginQuery,
        completion: @escaping (Result<LoginUser, LoginError>
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
                tokenStorage.accessToken = success.accessToken
                tokenStorage.refreshToken = success.refreshToken
                completion(.success(success.toDomain()))
            case .failure(let failure):
                switch failure {
                case .requestFailure(let error):
                    completion(.failure(.network("에러가 발생하였습니다")))
                    print("LoginService 네트워크 에러 -> \(failure.self)")
                    print(error.localizedDescription)
                case .apiKey, .invalidData, .tooManyRequest, .invalidURL:
                    completion(.failure(.network("에러가 발생하였습니다")))
                    print("LoginService 네트워크 에러 -> \(failure.self)")
                case .networkFailure:
                    completion(.failure(.network("인터넷 연결이 불안정합니다")))
                    print("LoginService 네트워크 에러 -> networkFailure")
                case .unknown(let statusCode):
                    switch statusCode {
                    case 400:
                        completion(.failure(.missingFields("아이디, 비밀번호를 입력해주세요")))
                        print("LoginService 로그인 에러 -> missingFields")
                    case 401:
                        completion(.failure(.accountVerify("계정을 다시 확인해주세요")))
                        print("LoginService 로그인 에러 -> accountVerify")
                    default:
                        completion(.failure(.unknown("알 수 없는 에러 발생")))
                        print("LoginService 로그인 에러 -> unknown")
                    }
                }
            }
        }
    }
}
