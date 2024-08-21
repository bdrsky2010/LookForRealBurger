//
//  LFRBNetworkRouter.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/21/24.
//

import Foundation

import Moya

enum LFRBNetworkRouter {
    case join(_ dto: JoinRequestDTO.JoinDTO)
    case emailValid(_ dto: JoinRequestDTO.EmailValidDTO)
    case login(_ dto: LoginRequestDTO)
}

extension LFRBNetworkRouter: LFRBTargetType {
    var path: String {
        switch self {
        case .join:       return "v1/users/join"
        case .emailValid: return "v1/validation/email"
        case .login:      return "v1/users/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .join:       return .post
        case .emailValid: return .post
        case .login:      return .post
        }
    }
    
    var task: Moya.Task {
        var parameters: [String: Any] = [:]
        
        switch self {
        case .join(let dto):       parameters = dto.asParameters
        case .emailValid(let dto): parameters = dto.asParameters
        case .login(let dto):      parameters = dto.asParameters
        }
        return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
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
        }
    }
}
