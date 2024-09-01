//
//  FollowRepository.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/27/24.
//

import Foundation

enum FollowError: Error {
    case network(_ message: String)
    case badRequest(_ message: String)
    case invalidToken(_ message: String)
    case forbidden(_ message: String)
    case alreadyFollowing(_ message: String)
    case notFoundUser(_ message: String)
    case expiredToken
    case unknown(_ message: String)
}

protocol FollowRepository {
    func followRequest(
        userId: String, completion: @escaping (Result<GetFollowStatus, FollowError>) -> Void
    )
    
    func followCancelRequest(
        userId: String, completion: @escaping (Result<GetFollowStatus, FollowError>) -> Void
    )
}

enum FollowAPIType: String {
    case follow
    case followCancel
}

final class DefaultFollowRepository {
    static let shared = DefaultFollowRepository()
    
    private let networkManager: NetworkManager
    
    private init(
        networkManager: NetworkManager = LFRBNetworkManager.shared
    ) {
        self.networkManager = networkManager
    }
}

extension DefaultFollowRepository: FollowRepository {
    func followRequest(
        userId: String, completion: @escaping (Result<GetFollowStatus, FollowError>) -> Void
    ) {
        networkManager.request(
            FollowRouter.follow(userId),
            of: FollowResponseDTO.self
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                completion(.success(success.toDomain()))
            case .failure(let failure):
                let followError = errorHandling(type: .follow, failure: failure)
                completion(.failure(followError))
            }
        }
    }
    
    func followCancelRequest(
        userId: String, completion: @escaping (Result<GetFollowStatus, FollowError>) -> Void
    ) {
        networkManager.request(
            FollowRouter.cancelFollow(userId),
            of: FollowResponseDTO.self
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                completion(.success(success.toDomain()))
            case .failure(let failure):
                let followError = errorHandling(type: .follow, failure: failure)
                completion(.failure(followError))
            }
        }
    }
}

extension DefaultFollowRepository {
    private func errorHandling(
        type: FollowAPIType,
        failure: NetworkError
    ) -> FollowError {
        let followError: FollowError
        switch failure {
        case .requestFailure(let error):
            followError = .network(R.Phrase.errorOccurred)
            print("FollowRepository \(type.rawValue) 에러 -> \(error.localizedDescription)")
        case .apiKey, .invalidData, .tooManyRequest, .invalidURL, .networkFailure:
            followError = .network(R.Phrase.errorOccurred)
            print("FollowRepository \(type.rawValue) 에러 -> \(failure.self)")
        case .unknown(let statusCode):
            switch statusCode {
            case 400:
                followError = .badRequest(R.Phrase.errorOccurred)
            case 401:
                followError = .invalidToken(R.Phrase.errorOccurred)
            case 403:
                followError = .forbidden(R.Phrase.errorOccurred)
            case 409:
                followError = .forbidden(R.Phrase.errorOccurred)
            case 410:
                followError = .notFoundUser(R.Phrase.notFoundUser)
            case 419:
                followError = .expiredToken
            default:
                followError = .unknown(R.Phrase.errorOccurred)
            }
        }
        print("FollowRepository \(type.rawValue) 에러 -> \(followError)")
        return followError
    }
}
