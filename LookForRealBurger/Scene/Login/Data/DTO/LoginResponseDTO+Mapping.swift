//
//  LoginResponseDTO+Mapping.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/21/24.
//

import Foundation

struct LoginResponseDTO: Decodable {
    let userId: String
    let email: String
    let nick: String
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nick
        case accessToken
        case refreshToken
    }
}

extension LoginResponseDTO {
    func toDomain() -> LoginUser {
        return LoginUser(
            userId: self.userId,
            email: self.email,
            nick: self.nick
        )
    }
}
