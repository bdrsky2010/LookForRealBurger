//
//  RequestDataTransferObject.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/17/24.
//

import Foundation

// MARK: Request Data Transfer Object
struct LFRBRequestDTO {
    private static let encoder = JSONEncoder()
    
    static func toDictionary<T: Encodable>(_ dto: T) -> [String: Any] {
        guard let data = try? encoder.encode(dto) else { return [:] }
        guard let parameters = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return [:] }
        return parameters
    }
}
