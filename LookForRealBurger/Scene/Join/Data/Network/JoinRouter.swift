//
//  JoinRouter.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/18/24.
//

import Foundation

import Moya

enum JoinRouter {
    case join(_ dto: JoinRequestDTO.JoinDTO)
    case emailValid(_ dto: JoinRequestDTO.EmailValidDTO)
}

extension JoinRouter: LFRBTargetType {
    var path: String {
        switch self {
        case .join:       return "v1/users/join"
        case .emailValid: return "v1/validation/email"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .join:       return .post
        case .emailValid: return .post
        }
    }
    
    var task: Moya.Task {
        var parameters: [String: Any] = [:]
        
        switch self {
        case .join(let dto):       parameters = dto.asParameters
        case .emailValid(let dto): parameters = dto.asParameters
        }
        return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
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
        }
    }
    
    
}
