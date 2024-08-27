//
//  UploadPostRequstDTO+Mapping.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/27/24.
//

import Foundation

struct UploadPostRequestDTO: Encodable {
    let title: String
    let price: Int
    let content: String
    let content1: String
    let content2: String?
    let content3: String?
    let content4: String?
    let content5: String?
    let productID: String
    let files: [String]?
    
    enum CodingKeys: String, CodingKey {
        case title
        case price
        case content
        case content1
        case content2
        case content3
        case content4
        case content5
        case productID = "product_id"
        case files
    }
}

extension UploadPostRequestDTO {
    var asParameters: [String: Any] {
        return LFRBRequestDTO.toDictionary(self)
    }
}
