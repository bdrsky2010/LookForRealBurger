//
//  JoinRequestDTO.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/17/24.
//

import Foundation

struct JoinRequestDTO: Encodable { }

extension JoinRequestDTO {
    struct JoinDTO: Encodable {
        let email: String
        let password: String
        let nick: String
        let phoneNum: String?
        let birthDay: String?
    }
}

extension JoinRequestDTO {
    struct EmailValidDTO: Encodable {
        let email: String
    }
}

extension JoinRequestDTO.JoinDTO {
    var asParameters: [String: Any] {
        return LFRBRequestDTO.toDictionary(self)
    }
}

extension JoinRequestDTO.EmailValidDTO {
    var asParameters: [String: Any] {
        return LFRBRequestDTO.toDictionary(self)
    }
}
