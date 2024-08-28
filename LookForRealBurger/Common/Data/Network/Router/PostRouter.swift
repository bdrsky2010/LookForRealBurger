//
//  PostRouter.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/28/24.
//

import Foundation

import Moya

enum PostRouter {
    case imageUpload(_ dto: UploadImageRequestDTO)
    case uploadPost(_ dto: UploadPostRequestDTO)
    case getPost(_ dto: GetPostRequestDTO)
    case getSinglePost(_ postId: String)
}

extension PostRouter: LFRBTargetType {
    var path: String {
        switch self {
        case .imageUpload:               return "v1/posts/files"
        case .uploadPost:                return "v1/posts"
        case .getPost:                   return "v1/posts"
        case .getSinglePost(let postId): return "v1/posts/\(postId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .imageUpload:   return .post
        case .uploadPost:    return .post
        case .getPost:       return .get
        case .getSinglePost: return .get
        }
    }
    
    var task: Moya.Task {
        var parameters: [String: Any] = [:]
        
        switch self {
        case .imageUpload(let dto):
            let multipartFormData = dto.files.map {
                MultipartFormData(provider: .data($0),
                                  name: "files",
                                  fileName: "LFRB_" + UUID().uuidString,
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
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .imageUpload:
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
        }
    }
}
