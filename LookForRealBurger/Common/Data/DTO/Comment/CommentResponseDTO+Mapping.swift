//
//  CommentResponseDTO+Mapping.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/27/24.
//

import Foundation

struct CommentResponseDTO: Decodable {
    let commentId: String
    let content: String
    let createdAt: String
    let creator: CreatorResponseDTO
    
    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case content
        case createdAt
        case creator
    }
}

extension CommentResponseDTO {
    func toDomain() -> RegisteredReview {
        return RegisteredReview(
            registerId: self.commentId,
            reviewID: self.content,
            createdAt: self.createdAt,
            reviewer: .init(
                userId: self.creator.userId,
                nick: self.creator.nick
            )
        )
    }
}

extension CommentResponseDTO {
    func toDomain() -> Comment {
        return Comment(
            id: self.commentId,
            content: self.content,
            createdAt: self.createdAt,
            creator: .init(
                userId: self.creator.userId,
                nick: self.creator.nick
            )
        )
    }
}
