//
//  PaymentRequestDTO+Mapping.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/3/24.
//

import Foundation

struct PaymentRequestDTO: Encodable {
    let impUid: String
    let postId: String
    
    enum CodingKeys: String, CodingKey {
        case impUid = "imp_uid"
        case postId = "post_id"
    }
}

extension PaymentRequestDTO {
    var asParameters: [String: Any] {
        return LFRBRequestDTO.toDictionary(self)
    }
}
