//
//  PostRouter.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/28/24.
//

import Foundation

import Moya

enum PostRouter {
    case uploadImage(_ dto: UploadImageRequestDTO)
    case uploadPost(_ dto: UploadPostRequestDTO)
    case getPost(_ dto: GetPostRequestDTO)
    case getSinglePost(_ postId: String)
    case updatePost(_ postId: String, _ dto: UploadPostRequestDTO)
    case deletePost(_ postId: String)
    case byUserPost(_ userId: String, _ dto: GetPostRequestDTO)
}

extension PostRouter: LFRBTargetType {
    var path: String {
        switch self {
        case .uploadImage:               return "v1/posts/files"
        case .uploadPost:                return "v1/posts"
        case .getPost:                   return "v1/posts"
        case .getSinglePost(let postId): return "v1/posts/\(postId)"
        case .updatePost(let postId, _): return "v1/posts/\(postId)"
        case .deletePost(let postId):    return "v1/posts/\(postId)"
        case .byUserPost(let userId, _): return "v1/posts/users/\(userId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .uploadImage:   return .post
        case .uploadPost:    return .post
        case .getPost:       return .get
        case .getSinglePost: return .get
        case .updatePost:    return .put
        case .deletePost:    return .delete
        case .byUserPost:    return .get
        }
    }
    
    var task: Moya.Task {
        var parameters: [String: Any] = [:]
        
        switch self {
        case .uploadImage(let dto):
            let multipartFormData = dto.files.map {
                MultipartFormData(provider: .data($0),
                                  name: "files",
                                  fileName: "LFRB_" + UUID().uuidString + ".jpg",
                                  mimeType: "image/jpg")
            }
            return .uploadMultipart(multipartFormData)
        case .uploadPost(let dto):
            parameters = dto.asParameters
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .getPost(let dto):
            parameters = dto.asParameters
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .getSinglePost:
            return .requestPlain
        case .updatePost(_, let dto):
            parameters = dto.asParameters
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .deletePost:
            return .requestPlain
        case .byUserPost(_, let dto):
            parameters = dto.asParameters
            print(parameters)
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .uploadImage:
            return [
                LFRBHeader.authorization.rawValue: UserDefaultsAccessStorage.shared.accessToken,
                LFRBHeader.contentType.rawValue: LFRBHeader.multipart.rawValue,
                LFRBHeader.sesacKey.rawValue: APIKEY.lslp.rawValue
            ]
        case .uploadPost:
            return [
                LFRBHeader.authorization.rawValue: UserDefaultsAccessStorage.shared.accessToken,
                LFRBHeader.contentType.rawValue: LFRBHeader.json.rawValue,
                LFRBHeader.sesacKey.rawValue: APIKEY.lslp.rawValue
            ]
        case .getPost:
            return [
                LFRBHeader.authorization.rawValue: UserDefaultsAccessStorage.shared.accessToken,
                LFRBHeader.sesacKey.rawValue: APIKEY.lslp.rawValue
            ]
        case .getSinglePost:
            return [
                LFRBHeader.authorization.rawValue: UserDefaultsAccessStorage.shared.accessToken,
                LFRBHeader.sesacKey.rawValue: APIKEY.lslp.rawValue
            ]
        case .updatePost:
            return [
                LFRBHeader.authorization.rawValue: UserDefaultsAccessStorage.shared.accessToken,
                LFRBHeader.contentType.rawValue: LFRBHeader.json.rawValue,
                LFRBHeader.sesacKey.rawValue: APIKEY.lslp.rawValue
            ]
        case .deletePost:
            return [
                LFRBHeader.authorization.rawValue: UserDefaultsAccessStorage.shared.accessToken,
                LFRBHeader.sesacKey.rawValue: APIKEY.lslp.rawValue
            ]
        case .byUserPost:
            return [
                LFRBHeader.authorization.rawValue: UserDefaultsAccessStorage.shared.accessToken,
                LFRBHeader.sesacKey.rawValue: APIKEY.lslp.rawValue
            ]
        }
    }
}
