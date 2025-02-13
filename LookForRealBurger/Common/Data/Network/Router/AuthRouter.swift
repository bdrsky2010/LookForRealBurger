//
//  AuthRouter.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/28/24.
//

import Foundation

import Moya

enum AuthRouter {
    case join(_ dto: JoinRequestDTO)
    case emailValid(_ dto: EmailValidRequestDTO)
    case login(_ dto: LoginRequestDTO)
    case accessTokenRefresh(_ refreshToken: String)
    case withdraw
}

extension AuthRouter: LFRBTargetType {
    var path: String {
        switch self {
        case .join:               return "v1/users/join"
        case .emailValid:         return "v1/validation/email"
        case .login:              return "v1/users/login"
        case .accessTokenRefresh: return "v1/auth/refresh"
        case .withdraw:           return "v1/users/withdraw"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .join:               return .post
        case .emailValid:         return .post
        case .login:              return .post
        case .accessTokenRefresh: return .get
        case .withdraw:           return .get
        }
    }
    
    var task: Moya.Task {
        var parameters: [String: Any] = [:]
        
        switch self {
        case .join(let dto):
            parameters = dto.asParameters
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .emailValid(let dto):
            parameters = dto.asParameters
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .login(let dto):
            parameters = dto.asParameters
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .accessTokenRefresh:
            return .requestPlain
        case .withdraw:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .join:
            return [
                LFRBHeader.contentType.rawValue: LFRBHeader.json.rawValue,
                LFRBHeader.sesacKey.rawValue: APIKEY.lslp.rawValue
            ]
        case .emailValid:
            return [
                LFRBHeader.contentType.rawValue: LFRBHeader.json.rawValue,
                LFRBHeader.sesacKey.rawValue: APIKEY.lslp.rawValue
            ]
        case .login:
            return [
                LFRBHeader.contentType.rawValue: LFRBHeader.json.rawValue,
                LFRBHeader.sesacKey.rawValue: APIKEY.lslp.rawValue
            ]
        case .accessTokenRefresh(let refreshToken):
            return [
                LFRBHeader.authorization.rawValue: UserDefaultsAccessStorage.shared.accessToken,
                LFRBHeader.sesacKey.rawValue: APIKEY.lslp.rawValue,
                LFRBHeader.refresh.rawValue: refreshToken
            ]
        case .withdraw:
            return [
                LFRBHeader.authorization.rawValue: UserDefaultsAccessStorage.shared.accessToken,
                LFRBHeader.sesacKey.rawValue: APIKEY.lslp.rawValue,
            ]
        }
    }
}
