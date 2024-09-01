//
//  ProfileResponseDTO.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/30/24.
//

import Foundation

struct ProfileResponseDTO: Decodable {
    struct ProfileFollowResponseDTO: Decodable {
        let userId: String
        let nick: String
        let profileImage: String?
        
        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case nick
            case profileImage
        }
    }
    
    let userId: String
    let email: String?
    let nick: String
    let phone: String?
    let birthDay: String?
    let profileImage: String?
    let followers: [ProfileFollowResponseDTO]
    let following: [ProfileFollowResponseDTO]
    let posts: [String]
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nick
        case phone = "phoneNum"
        case birthDay
        case profileImage
        case followers
        case following
        case posts
    }
}

extension ProfileResponseDTO {
    func toDomain() -> GetMyUserId {
        return GetMyUserId(userId: self.userId)
    }
}

extension ProfileResponseDTO {
    func toDomain() -> GetProfile {
        return GetProfile(
            userId: self.userId,
            nick: self.nick,
            followers: self.followers.map {
                GetFollow(userId: $0.userId, nick: $0.userId)
            },
            following: self.following.map {
                GetFollow(userId: $0.userId, nick: $0.nick)
            },
            posts: self.posts
        )
    }
}
