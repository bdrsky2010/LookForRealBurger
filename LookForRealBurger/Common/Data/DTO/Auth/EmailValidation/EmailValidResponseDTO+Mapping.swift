//
//  EmailValidResponseDTO+Mapping.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/28/24.
//

import Foundation

struct EmailValidResponseDTO: Decodable {
    let message: String
}

extension EmailValidResponseDTO {
    func toDomain() -> EmailValidMessage {
        return EmailValidMessage(message: self.message)
    }
}
