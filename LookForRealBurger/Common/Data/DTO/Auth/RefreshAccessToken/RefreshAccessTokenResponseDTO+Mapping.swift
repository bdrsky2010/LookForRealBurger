//
//  RefreshAccessTokenResponseDTO.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/28/24.
//

import Foundation

struct RefreshAccessTokenResponseDTO: Decodable {
    let accessToken: String
}

extension RefreshAccessTokenResponseDTO {
    func toDomain() -> AccessToken {
        return AccessToken(accessToken: self.accessToken)
    }
}
