//
//  KakaoLocalRequestDTO+Mapping.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/22/24.
//

import Foundation

struct KakaoLocalRequestDTO: Encodable {
    let query: String
    let categoryGroupCode: String = "FD6"
    let x: String
    let y: String
    var page: Int
    let size: Int = 15
    let sort: String = "distance"
    
    enum CodingKeys: String, CodingKey {
        case query
        case categoryGroupCode = "category_group_code"
        case x
        case y
        case page
        case size
        case sort
    }
}

extension KakaoLocalRequestDTO {
    var asParameters: [String: Any] {
        return LFRBRequestDTO.toDictionary(self)
    }
}
