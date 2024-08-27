//
//  JoinResponseDTO.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/17/24.
//

import Foundation

struct JoinResponseDTO: Decodable {
    let userId: String
    let email: String
    let nick: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nick
    }
}

extension JoinResponseDTO {
    func toDomain() -> JoinUser {
        return JoinUser(nick: self.nick)
    }
}
