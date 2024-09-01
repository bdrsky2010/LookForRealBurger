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
    case updateComment(_ postId: String, _ commentId: String, _ dto: CommentRequestDTO)
    case deleteComment(_ postId: String, _ commentId: String)
}

extension CommentRouter: LFRBTargetType {
    var path: String {
        switch self {
        case .comment(let postId, _):                      return "v1/posts/\(postId)/comments"
        case .updateComment(let postID, let commentId, _): return "v1/posts/\(postID)/comments/\(commentId)"
        case .deleteComment(let postID, let commentId): return "v1/posts/\(postID)/comments/\(commentId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .comment:       return .post
        case .updateComment: return .put
        case .deleteComment: return .delete
        }
    }
    
    var task: Moya.Task {
        var parameters: [String: Any] = [:]
        
        switch self {
        case .comment(_, let dto):
            parameters = dto.asParameters
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .updateComment(_, _, let dto):
            parameters = dto.asParameters
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .deleteComment:
            return .requestPlain
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
        case .updateComment:
            return [
                LFRBHeader.authorization.rawValue: UserDefaultsAccessStorage.shared.accessToken,
                LFRBHeader.contentType.rawValue: LFRBHeader.json.rawValue,
                LFRBHeader.sesacKey.rawValue: APIKEY.lslp.rawValue
            ]
        case .deleteComment:
            return [
                LFRBHeader.authorization.rawValue: UserDefaultsAccessStorage.shared.accessToken,
                LFRBHeader.sesacKey.rawValue: APIKEY.lslp.rawValue
            ]
        }
    }
}
