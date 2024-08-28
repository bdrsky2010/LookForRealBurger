//
//  PostRouter.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/28/24.
//

import Foundation

import Moya

enum PostRouter {
    case getPost(_ dto: GetPostRequestDTO)
    case uploadPost(_ dto: UploadPostRequestDTO)
    case imageUpload(_ dto: UploadImageRequestDTO)
}

extension PostRouter: LFRBTargetType {
    var path: String {
        switch self {
        case .getPost:     return "v1/posts"
        case .uploadPost:  return "v1/posts"
        case .imageUpload: return "v1/posts/files"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPost:     return .get
        case .uploadPost:  return .post
        case .imageUpload: return .post
        }
    }
    
    var task: Moya.Task {
        var parameters: [String: Any] = [:]
        
        switch self {
        case .getPost(let dto):
            parameters = dto.asParameters
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .uploadPost(let dto):
            parameters = dto.asParameters
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .imageUpload(let dto):
            let multipartFormData = dto.files.map {
                MultipartFormData(provider: .data($0),
                                  name: "files",
                                  fileName: "LFRB_" + UUID().uuidString,
                                  mimeType: "image/jpg")
            }
            return .uploadMultipart(multipartFormData)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getPost:
            return [
                LFRBHeader.authorization.rawValue: UserDefaultsAccessStorage.shared.accessToken,
                LFRBHeader.sesacKey.rawValue: APIKEY.lslp.rawValue
            ]
        case .uploadPost:
            return [
                LFRBHeader.authorization.rawValue: UserDefaultsAccessStorage.shared.accessToken,
                LFRBHeader.contentType.rawValue: LFRBHeader.json.rawValue,
                LFRBHeader.sesacKey.rawValue: APIKEY.lslp.rawValue
            ]
        case .imageUpload:
            return [
                LFRBHeader.authorization.rawValue: UserDefaultsAccessStorage.shared.accessToken,
                LFRBHeader.contentType.rawValue: LFRBHeader.multipart.rawValue,
                LFRBHeader.sesacKey.rawValue: APIKEY.lslp.rawValue
            ]
        }
    }
}
