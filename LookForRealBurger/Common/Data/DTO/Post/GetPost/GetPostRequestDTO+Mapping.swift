//
//  GetPostRequestDTO+Mapping.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/26/24.
//

import Foundation

struct GetPostRequestDTO: Encodable {
    let next: String?
    let limit: String?
    let productId: String?
    
    enum CodingKeys: String, CodingKey {
        case next
        case limit
        case productId = "product_id"
    }
}

extension GetPostRequestDTO {
    var asParameters: [String: Any] {
        return LFRBRequestDTO.toDictionary(self)
    }
}
