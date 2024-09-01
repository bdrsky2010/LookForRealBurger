//
//  FollowResponseDTO+Mapping.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/1/24.
//

import Foundation

struct FollowResponseDTO: Decodable {
    let nick: String
    let opponentNick: String
    let followingStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case nick
        case opponentNick = "opponent_nick"
        case followingStatus = "following_status"
    }
}

extension FollowResponseDTO {
    func toDomain() -> GetFollowStatus {
        return GetFollowStatus(followingStatus: self.followingStatus)
    }
}
