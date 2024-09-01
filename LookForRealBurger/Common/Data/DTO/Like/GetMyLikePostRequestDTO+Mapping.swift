//
//  GetMyLikePostRequestDTO+Mapping.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/1/24.
//

import Foundation

struct GetMyLikePostRequestDTO: Encodable {
    let next: String?
    let limit: String
}

extension GetMyLikePostRequestDTO {
    var asParameters: [String: Any] {
        return LFRBRequestDTO.toDictionary(self)
    }
}
