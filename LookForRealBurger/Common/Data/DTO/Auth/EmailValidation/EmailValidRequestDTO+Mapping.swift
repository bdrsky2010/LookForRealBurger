//
//  EmailValidRequestDTO+Mapping.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/28/24.
//

import Foundation

struct EmailValidRequestDTO: Encodable {
    let email: String
}

extension EmailValidRequestDTO {
    var asParameters: [String: Any] {
        return LFRBRequestDTO.toDictionary(self)
    }
}
