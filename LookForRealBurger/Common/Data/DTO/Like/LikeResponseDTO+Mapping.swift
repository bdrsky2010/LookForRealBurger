//
//  LikeResponseDTO+Mapping.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/1/24.
//

import Foundation

struct LikeResponseDTO: Decodable {
    let likeStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case likeStatus = "like_status"
    }
}

extension LikeResponseDTO {
    func toDomain() -> GetIsLikePost {
        return GetIsLikePost(isLike: self.likeStatus)
    }
}

extension LikeResponseDTO {
    func toDomain() -> GetIsBookmarkPost {
        return GetIsBookmarkPost(isBookmark: self.likeStatus)
    }
}
