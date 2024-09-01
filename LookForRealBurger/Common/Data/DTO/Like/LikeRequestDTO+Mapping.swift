//
//  LikeRequestDTO+Mapping.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/1/24.
//

import Foundation

struct LikeRequestDTO: Encodable {
    let likeStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case likeStatus = "like_status"
    }
}

extension LikeRequestDTO {
    var asParameters: [String: Any] {
        return LFRBRequestDTO.toDictionary(self)
    }
}
