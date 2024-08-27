//
//  LoginRequestDTO.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/21/24.
//

import Foundation

struct LoginRequestDTO: Encodable {
    let email: String
    let password: String
}

extension LoginRequestDTO {
    var asParameters: [String: Any] {
        return LFRBRequestDTO.toDictionary(self)
    }
}
