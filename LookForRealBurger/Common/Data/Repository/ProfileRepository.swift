//
//  ProfileRepository.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/27/24.
//

import Foundation

enum ProfileError: Error {
    // 공통
    case network(_ message: String)
    case invalidToken(_ message: String)
    case forbidden(_ message: String)
    case expiredToken
    case unknown(_ message: String)
}

protocol ProfileRepository {
    func myProfileRequest(completion: @escaping (Result<GetProfile, ProfileError>) -> Void)
    func getOtherProfileRequest(
        query: GetOtherProfileQuery,
        completion: @escaping (Result<GetProfile, ProfileError>) -> Void
    )
}

final class DefaultProfileRepository {
    static let shared = DefaultProfileRepository()
    
    private let network: NetworkManager
    
    private init(
        network: NetworkManager = LFRBNetworkManager.shared
    ) {
        self.network = network
    }
}

extension DefaultProfileRepository: ProfileRepository {
    func myProfileRequest(completion: @escaping (Result<GetProfile, ProfileError>) -> Void) {
        network.request(
            ProfileRouter.myProfile,
            of: ProfileResponseDTO.self
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                completion(.success(success.toDomain()))
            case .failure(let failure):
                let profileError = errorHandling(failure: failure)
                completion(.failure(profileError))
            }
        }
    }
    
    func getOtherProfileRequest(
        query: GetOtherProfileQuery,
        completion: @escaping (Result<GetProfile, ProfileError>) -> Void
    ) {
        network.request(
            ProfileRouter.otherProfile(query.userId),
            of: ProfileResponseDTO.self
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                completion(.success(success.toDomain()))
            case .failure(let failure):
                let profileError = errorHandling(failure: failure)
                completion(.failure(profileError))
            }
        }
    }
}

extension DefaultProfileRepository {
    private func errorHandling(failure: NetworkError) -> ProfileError {
        let profileError: ProfileError
        switch failure {
        case .requestFailure(let error):
            profileError = .network(R.Phrase.errorOccurred)
            print("ProfileRepository network 에러 발생 -> \(error)")
        case .apiKey, .invalidData, .tooManyRequest, .invalidURL:
            profileError = .network(R.Phrase.errorOccurred)
            print("ProfileRepository network 에러 발생 -> \(failure)")
        case .networkFailure:
            profileError = .network(R.Phrase.errorOccurred)
            print("ProfileRepository network 에러 발생 -> \(failure)")
        case .unknown(let statusCode):
            switch statusCode {
            case 401:
                profileError = .invalidToken(R.Phrase.errorOccurred)
            case 403:
                profileError = .forbidden(R.Phrase.errorOccurred)
            case 419:
                profileError = .expiredToken
            default:
                profileError = .unknown(R.Phrase.errorOccurred)
            }
        }
        print("ProfileRepository 에러 -> \(profileError)")
        return profileError
    }
}
