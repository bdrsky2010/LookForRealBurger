//
//  CommentRouter.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/27/24.
//

import Foundation

import Moya

enum CommentRouter {
    case comment(_ postId: String, _ dto: CommentRequestDTO)
}

extension CommentRouter: LFRBTargetType {
    var path: String {
        switch self {
        case .comment(let postId, _): return "v1/posts/\(postId)/comments"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .comment: return .post
        }
    }
    
    var task: Moya.Task {
        var parameters: [String: Any] = [:]
        
        switch self {
        case .comment(_, let dto):
            parameters = dto.asParameters
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .comment:
            return [
                LFRBHeader.authorization.rawValue: UserDefaultsAccessStorage.shared.accessToken,
                LFRBHeader.contentType.rawValue: LFRBHeader.json.rawValue,
                LFRBHeader.sesacKey.rawValue: APIKEY.lslp.rawValue
            ]
        }
    }
}
