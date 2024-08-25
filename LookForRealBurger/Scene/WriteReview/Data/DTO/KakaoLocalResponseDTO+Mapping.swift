//
//  KakaoLocalResponseDTO.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/22/24.
//

import Foundation

struct KakaoLocalResponseDTO: Decodable {
    struct Meta: Decodable {
        let totalCount: Int
        let isEnd: Bool
        
        enum CodingKeys: String, CodingKey {
            case totalCount = "total_count"
            case isEnd = "is_end"
        }
    }
    
    struct Document: Decodable {
        let id: String
        let placeName: String
        let distance: String? // 단위 meter
        let placeUrl: String
        let category: String
        let address: String
        let roadAddress: String
        let phone: String
        let x: String
        let y: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case placeName = "place_name"
            case distance
            case placeUrl = "place_url"
            case category = "category_name"
            case address = "address_name"
            case roadAddress = "road_address_name"
            case phone
            case x
            case y
        }
        
        var categories: [String] {
            category.components(separatedBy: " > ")
        }
    }
    
    let meta: Meta
    let documents: [Document]
}

extension KakaoLocalResponseDTO {
    func toDomain(query: String, nextPage: Int) -> BurgerPage {
        let burgerCategories = Set(["햄버거", query])
        let burgerHouses = self.documents
            .filter {
                let categories = Set($0.categories)
                return !burgerCategories.intersection(categories).isEmpty
            }
            .map {
                return BurgerHouse(
                    id: $0.id,
                    name: $0.placeName,
                    placeUrl: $0.placeUrl,
                    address: $0.address,
                    roadAddress: $0.roadAddress,
                    phone: $0.phone,
                    x: Double($0.x),
                    y: Double($0.y)
                )
            }
        return BurgerPage(nextPage: nextPage, isEndPage: self.meta.isEnd, burgerHouses: burgerHouses)
    }
}
