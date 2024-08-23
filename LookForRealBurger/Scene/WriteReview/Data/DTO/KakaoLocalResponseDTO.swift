//
//  KakaoLocalResponseDTO.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/22/24.
//

import Foundation

struct KakaoLocalResponseDTO: Decodable {
    struct Meta: Decodable {
        let isEnd: Bool
        
        enum CodingKeys: String, CodingKey {
            case isEnd = "is_end"
        }
    }
    
    struct Document: Decodable {
        let id: String
        let placeName: String
        let placeUrl: String
        let address: String
        let roadAddress: String
        let phone: String
        let x: String
        let y: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case placeName = "place_name"
            case placeUrl = "place_url"
            case address = "address_name"
            case roadAddress = "road_address_name"
            case phone
            case x
            case y
        }
    }
    
    let meta: Meta
    let documents: [Document]
}