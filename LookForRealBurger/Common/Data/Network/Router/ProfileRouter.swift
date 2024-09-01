//
//  ProfileRouter.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/28/24.
//

import Foundation

import Moya

enum ProfileRouter {
    case myProfile
    case updateMyProfile(_ dto: UpdateProfileRequestDTO)
    case otherProfile(_ userId: String)
}

extension ProfileRouter: LFRBTargetType {
    var path: String {
        switch self {
        case .myProfile:                return "v1/users/me/profile"
        case .updateMyProfile:          return "v1/users/me/profile"
        case .otherProfile(let userId): return "v1/users/\(userId)/profile"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .myProfile:       return .get
        case .updateMyProfile: return .put
        case .otherProfile:    return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .myProfile:
            return .requestPlain
        case .updateMyProfile(let dto):
            let parameters = dto.asParameters
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .otherProfile:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .myProfile:
            return [
                LFRBHeader.authorization.rawValue: UserDefaultsAccessStorage.shared.accessToken,
                LFRBHeader.sesacKey.rawValue: APIKEY.lslp.rawValue
            ]
        case .updateMyProfile:
            return [
                LFRBHeader.authorization.rawValue: UserDefaultsAccessStorage.shared.accessToken,
                LFRBHeader.contentType.rawValue: LFRBHeader.multipart.rawValue,
                LFRBHeader.sesacKey.rawValue: APIKEY.lslp.rawValue
            ]
        case .otherProfile:
            return [
                LFRBHeader.authorization.rawValue: UserDefaultsAccessStorage.shared.accessToken,
                LFRBHeader.sesacKey.rawValue: APIKEY.lslp.rawValue
            ]
        }
    }
}
