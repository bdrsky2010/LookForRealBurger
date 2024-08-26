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
