//
//  PaymentResponseDTO+Mapping.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/3/24.
//

import Foundation
/*
 "buyer_id": "6623d202d868f6237bdc8b13",
 "post_id": "66151df5c2b8530461af6c28",
 "merchant_uid": "20240401JpzwCVJbqI1713608669",
 "productName": " ", // post title
 "price": 100, // price
 "paidAt": "2023-12-27T10:30:27.000Z"
 */
struct PaymentResponseDTO: Decodable {
    let buyerId: String
    let postId: String
    let merchantUid: String
    let productName: String
    let price: Int
    let paidAt: String
    
    enum CodingKeys: String, CodingKey {
        case buyerId = "buyer_id"
        case postId = "post_id"
        case merchantUid = "merchant_uid"
        case productName
        case price
        case paidAt
    }
}
