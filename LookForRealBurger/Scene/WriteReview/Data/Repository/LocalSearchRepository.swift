//
//  LocalSearchRepository.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/25/24.
//

import Foundation

import Alamofire

enum KakaoAPIError: Error {
    case invalidURL(message: String)
    case noData(message: String)
    case badRequest(message: String)
    case unauthorized(message: String)
    case forbidden(message: String)
    case tooManyRequest(message: String)
    case internalServerError(message: String)
    case badGateway(message: String)
    case serviceUnavilable(message: String)
    case unknown(message: String)
}

protocol LocalSearchRepository {
    func request(
        query: LocalSearchQuery,
        completion: @escaping (Result<BurgerPage, KakaoAPIError>
        ) -> Void)
}

final class KakaoLocalSearchRepository: LocalSearchRepository {
    func request(
        query: LocalSearchQuery,
        completion: @escaping (Result<BurgerPage, KakaoAPIError>
        ) -> Void) {
        do {
            let headers: HTTPHeaders = ["Authorization": "KakaoAK \(APIKEY.kakaoLocal.rawValue)"]
            let requestDTO = KakaoLocalRequestDTO(
                query: query.query,
                x: String(query.x),
                y: String(query.y),
                page: query.page
            )
            let baseURL = APIURL.kakaoLocal.rawValue
            let endPoint = baseURL + "v2/local/search/keyword"
            let url = try endPoint.asURL()
            
            AF.request(url, parameters: requestDTO.asParameters, headers: headers)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: KakaoLocalResponseDTO.self) { response in
                    switch response.result {
                    case .success(let value):
                        if value.meta.totalCount != 0 {
                            let result = value.toDomain(query: query.query, nextPage: query.page + 1)
                            completion(.success(result))
                        } else {
                            completion(.failure(.noData(message: R.Phrase.noSearchResult)))
                        }
                    case .failure(let error):
                        switch response.response?.statusCode {
                        case 400:
                            print("error status code 400, \(error.localizedDescription)")
                            completion(.failure(.badRequest(message: R.Phrase.wrongSearchText)))
                        case 401:
                            print("error status code 401, \(error.localizedDescription)")
                            completion(.failure(.unauthorized(message: R.Phrase.errorOccurred)))
                        case 403:
                            print("error status code 403, \(error.localizedDescription)")
                            completion(.failure(.forbidden(message: R.Phrase.errorOccurred)))
                        case 429:
                            print("error status code 429, \(error.localizedDescription)")
                            completion(.failure(.tooManyRequest(message: R.Phrase.errorOccurred)))
                        case 500:
                            print("error status code 500, \(error.localizedDescription)")
                            completion(.failure(.internalServerError(message: R.Phrase.errorOccurred)))
                        case 502:
                            print("error status code 502, \(error.localizedDescription)")
                            completion(.failure(.badGateway(message: R.Phrase.unstableConnection)))
                        case 503:
                            print("error status code 503, \(error.localizedDescription)")
                            completion(.failure(.serviceUnavilable(message: R.Phrase.checkSearchService)))
                        default:
                            print("unknown error, \(error.localizedDescription)")
                            completion(.failure(.unknown(message: R.Phrase.errorOccurred)))
                        }
                    }
                }
        } catch {
            print("invalid url error, \(error.localizedDescription)")
            completion(.failure(.invalidURL(message: R.Phrase.errorOccurred)))
        }
    }
}
