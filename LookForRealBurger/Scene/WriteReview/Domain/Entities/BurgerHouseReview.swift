//
//  BurgerHouseReview.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/27/24.
//

import Foundation

struct BurgerHouseReview {
    let reviewId: String
    let title: String
    let rating: Int
    let content: String
    let burgerHousePostId: String
    let createdAt: String
    let creator: Creator
    let files: [String]
    let likeUserIds: [String]
    let bookmarkUserIds: [String]
    let comments: [Comment]
}

struct Creator {
    let userId: String
    let nick: String
}

struct Comment {
    let commentId: String
    let content: String
    let createdAt: String
    let creator: Creator
}
