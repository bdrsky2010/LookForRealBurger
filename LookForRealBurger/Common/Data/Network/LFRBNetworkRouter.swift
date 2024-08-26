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
    case getPost(_ dto: GetPostRequestDTO)
    case uploadPost(_ dto: UploadPostRequestDTO)
    case imageUpload(_ files: [Data])
}

extension LFRBNetworkRouter: LFRBTargetType {
    var path: String {
        switch self {
        case .join:        return "v1/users/join"
        case .emailValid:  return "v1/validation/email"
        case .login:       return "v1/users/login"
        case .getPost:     return "v1/posts"
        case .uploadPost:  return "v1/posts"
        case .imageUpload: return "v1/posts/files"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .join:        return .post
        case .emailValid:  return .post
        case .login:       return .post
        case .getPost:     return .get
        case .uploadPost:  return .post
        case .imageUpload: return .post
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
        case .getPost(let dto):
            parameters = dto.asParameters
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .uploadPost(let dto):
            parameters = dto.asParameters
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .imageUpload(let files):
            let multipartFormData = files.map {
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
