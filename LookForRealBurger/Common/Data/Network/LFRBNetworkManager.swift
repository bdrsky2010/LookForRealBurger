//
//  LFRBNetworkManager.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/18/24.
//

import Foundation

import Moya

enum NetworkError: Error {
    case requestFailure(Error)
    case apiKey
    case invalidData
    case tooManyRequest
    case invalidURL
    case networkFailure
    case unknown(_ statusCode: Int)
}

final class LFRBNetworkManager {
    static let shared = LFRBNetworkManager()
    
    private init() { }
    
    func requestAPI<Target: TargetType, T: Decodable>(
        _ targetType: Target,
        of type: T.Type,
        completionHandler: @escaping (Result<T, NetworkError>
        ) -> Void) {
        let provider = MoyaProvider<Target>()
        print(targetType.baseURL.description)
        provider.request(targetType) { result in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    do {
                        let value = try response.map(type.self)
                        completionHandler(.success(value))
                    } catch {
                        completionHandler(.failure(.invalidData))
                    }
                case 420:
                    completionHandler(.failure(.apiKey))
                case 429:
                    completionHandler(.failure(.tooManyRequest))
                case 444:
                    completionHandler(.failure(.invalidURL))
                case 500:
                    completionHandler(.failure(.networkFailure))
                default:
                    completionHandler(.failure(.unknown(response.statusCode)))
                }
            case .failure(let error):
                completionHandler(.failure(.requestFailure(error)))
            }
        }
    }
}
