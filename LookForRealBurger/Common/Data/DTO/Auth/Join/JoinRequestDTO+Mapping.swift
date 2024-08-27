//
//  JoinRequestDTO.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/17/24.
//

import Foundation

struct JoinRequestDTO: Encodable {
    let email: String
    let password: String
    let nick: String
    let phoneNum: String?
    let birthDay: String?
}

extension JoinRequestDTO {
    var asParameters: [String: Any] {
        return LFRBRequestDTO.toDictionary(self)
    }
}
