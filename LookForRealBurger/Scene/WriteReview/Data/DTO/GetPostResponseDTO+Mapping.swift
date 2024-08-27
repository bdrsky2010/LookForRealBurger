//
//  GetPostResponseDTO+Mapping.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/26/24.
//

import Foundation

struct GetPostResponseDTO: Decodable {
    let data: [PostResponseDTO]
    let nextCursor: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
}

extension GetPostResponseDTO {
    func toDomain() -> [GetBurgerHouse] {
        return self.data.map {
            return GetBurgerHouse(
                burgerHouseId: $0.postId,
                name: $0.title,
                totalRating: $0.price,
                hashtagName: $0.content,
                longitude: $0.content1,
                latitude: $0.content2 ?? "",
                roadAddress: $0.content3 ?? "",
                phone: $0.content4 ?? "",
                localId: $0.content5 ?? "",
                productId: $0.productId,
                eatenUserIds: $0.likes,
                plannedUserIds: $0.likes2,
                hashTags: $0.hashTags,
                reviewIds: $0.comments.map { $0.content }
            )
        }
    }
}
