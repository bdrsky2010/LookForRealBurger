//
//  UpdateProfileRequest.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/1/24.
//

import Foundation

struct UpdateProfileRequestDTO: Encodable {
    let nick: String
}

extension UpdateProfileRequestDTO {
    var asParameters: [String: Any] {
        return LFRBRequestDTO.toDictionary(self)
    }
}
