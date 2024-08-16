//
//  LFRBRequestDTO+Mapping.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/16/24.
//

import Foundation

// MARK: Request Data Transfer Object
struct LFRBRequestDTO {
    private static let encoder = JSONEncoder()
    
    private static func toDictionary<T: Encodable>(_ dto: T) -> [String: Any] {
        guard let data = try? encoder.encode(dto) else { return [:] }
        guard let parameters = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return [:] }
        return parameters
    }
}

extension LFRBRequestDTO {
    struct JoinDTO: Encodable {
        let email: String
        let password: String
        let nick: String
        let phoneNum: String?
        let birthDay: String?
    }
}

extension LFRBRequestDTO.JoinDTO {
    var asParameters: [String: Any] {
        return LFRBRequestDTO.toDictionary(self)
    }
}
