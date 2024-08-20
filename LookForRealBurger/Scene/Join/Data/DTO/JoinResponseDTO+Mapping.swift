//
//  JoinResponseDTO.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/17/24.
//

import Foundation

struct JoinResponseDTO { }

extension JoinResponseDTO {
    struct JoinDTO: Decodable {
        let userId: String
        let email: String
        let nick: String
        
        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case email
            case nick
        }
    }
}

extension JoinResponseDTO {
    struct EmailValidDTO: Decodable {
        let message: String
    }
}

extension JoinResponseDTO.JoinDTO {
    func toDomain() -> JoinUser {
        return JoinUser(nick: self.nick)
    }
}

extension JoinResponseDTO.EmailValidDTO {
    func toDomain() -> EmailValidMessage {
        return EmailValidMessage(message: self.message)
    }
}
