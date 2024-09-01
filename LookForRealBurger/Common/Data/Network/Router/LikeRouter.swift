//
//  LikeRouter.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/28/24.
//

import Foundation

import Moya

enum LikeRouter {
    case like(_ postId: String, _ dto: LikeRequestDTO)
    case like2(_ postId: String, _ dto: LikeRequestDTO)
    case myLikePost(_ dto: GetPostRequestDTO)
    case myLikePost2(_ dto: GetPostRequestDTO)
}

extension LikeRouter: LFRBTargetType {
    var path: String {
        switch self {
        case .like(let postId, _):  return "v1/posts/\(postId)/like"
        case .like2(let postId, _): return "v1/posts/\(postId)/like-2"
        case .myLikePost:           return "v1/posts/likes/me"
        case .myLikePost2:          return "v1/posts/likes-2/me"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .like, .like2:             return .post
        case .myLikePost, .myLikePost2: return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .like(_, let dto), .like2(_, let dto):
            return .requestParameters(parameters: dto.asParameters, encoding: JSONEncoding.default)
        case .myLikePost(let dto), .myLikePost2(let dto):
            let parameters = dto.asParameters
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .like, .like2:
            return [
                LFRBHeader.authorization.rawValue: UserDefaultsAccessStorage.shared.accessToken,
                LFRBHeader.sesacKey.rawValue: APIKEY.lslp.rawValue
            ]
        case .myLikePost, .myLikePost2:
            return [
                LFRBHeader.authorization.rawValue: UserDefaultsAccessStorage.shared.accessToken,
                LFRBHeader.sesacKey.rawValue: APIKEY.lslp.rawValue
            ]
        }
    }
}
