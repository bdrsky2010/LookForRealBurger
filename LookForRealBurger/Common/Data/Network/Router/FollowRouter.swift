//
//  FollowRouter.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/28/24.
//

import Foundation

import Moya

enum FollowRouter {
    case follow(_ userId: String)
    case cancelFollow(_ userId: String)
}

extension FollowRouter: LFRBTargetType {
    var path: String {
        switch self {
        case .follow(let userId), .cancelFollow(let userId): 
            return "v1/follow/\(userId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .follow:       return .post
        case .cancelFollow: return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .follow, .cancelFollow: 
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .follow, .cancelFollow:
            return [
                LFRBHeader.authorization.rawValue: UserDefaultsAccessStorage.shared.accessToken,
                LFRBHeader.sesacKey.rawValue: APIKEY.lslp.rawValue
            ]
        }
    }
}
