//
//  GetPostResponseDTO+Mapping.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/26/24.
//

import Foundation

struct GetPostResponseDTO: Decodable {
    struct Post: Decodable {
        struct Creator: Decodable {
            let userId: String
            let nick: String
            let profileImage: String?
            
            enum CodingKeys: String, CodingKey {
                case userId = "user_id"
                case nick
                case profileImage
            }
        }
        
        struct Comment: Decodable {
            let commentId: String
            let content: String
            let createdAt: String
            let creator: Creator
            
            enum CodingKeys: String, CodingKey {
                case commentId = "comment_id"
                case content
                case createdAt
                case creator
            }
        }
        
        let postId: String
        let productId: String
        let title: String
        let price: Int
        let content: String
        let content1: String
        let content2: String
        let content3: String
        let content4: String
        let content5: String
        let createdAt: String
        let creator: Creator
        let files: [String]
        let likes: [String]
        let likes2: [String]
        let hashTags: [String]
        let comments: [Comment]
        
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
            case hashTags
            case comments
        }
    }
    
    let data: [Post]
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
                latitude: $0.content2,
                roadAddress: $0.content3,
                phone: $0.content4,
                localId: $0.content5,
                productId: $0.productId,
                eatenUserIds: $0.likes,
                plannedUserIds: $0.likes2,
                hashTags: $0.hashTags,
                reviewIds: $0.comments.map { $0.content })
        }
    }
}
