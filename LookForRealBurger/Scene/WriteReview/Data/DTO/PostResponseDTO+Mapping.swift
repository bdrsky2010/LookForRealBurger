//
//  PostResponseDTO+Mapping.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/27/24.
//

import Foundation

struct PostResponseDTO: Decodable {
    let postId: String
    let productId: String
    let title: String
    let price: Int
    let content: String
    let content1: String
    let content2: String?
    let content3: String?
    let content4: String?
    let content5: String?
    let createdAt: String
    let creator: CreatorResponseDTO
    let files: [String]
    let likes: [String]
    let likes2: [String]
    let buyers: [String]
    let hashTags: [String]
    let comments: [CommentResponseDTO]
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case productId = "product_id"
        case title
        case price
        case content
        case content1
        case content2
        case content3
        case content4
        case content5
        case createdAt
        case creator
        case files
        case likes
        case likes2
        case buyers
        case hashTags
        case comments
    }
}

extension PostResponseDTO {
    func toDomain() -> GetBurgerHouse {
        return GetBurgerHouse(
            burgerHouseId: self.postId,
            name: self.title,
            totalRating: self.price,
            hashtagName: self.content,
            longitude: self.content1,
            latitude: self.content2 ?? "",
            roadAddress: self.content3 ?? "",
            phone: self.content4 ?? "",
            localId: self.content5 ?? "",
            productId: self.productId,
            eatenUserIds: self.likes,
            plannedUserIds: self.likes2,
            hashTags: self.hashTags,
            reviewIds: self.comments.map { $0.content }
        )
    }
}

extension PostResponseDTO {
    func toDomain() -> BurgerHouseReview {
        return BurgerHouseReview(
            reviewId: self.postId,
            title: self.title,
            rating: self.price,
            content: self.content,
            burgerHousePostId: self.content1,
            createdAt: self.createdAt,
            creator: .init(userId: self.creator.userId, nick: self.creator.nick),
            files: self.files,
            likeUserIds: self.likes,
            bookmarkUserIds: self.likes2,
            comments: self.comments.map {
                Comment(
                    commentId: $0.commentId,
                    content: $0.content,
                    createdAt: $0.createdAt,
                    creator: .init(userId: $0.creator.userId, nick: $0.creator.nick))
            }
        )
    }
}
