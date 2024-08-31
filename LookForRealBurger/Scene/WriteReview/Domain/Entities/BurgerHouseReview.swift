//
//  BurgerHouseReview.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/27/24.
//

import Foundation

struct BurgerHouseReview: Hashable, Identifiable {
    let id: String
    let title: String
    let rating: Int
    let content: String
    let burgerHousePostId: String
    let createdAt: String
    let creator: Creator
    let files: [String]
    var likeUserIds: [String]
    var bookmarkUserIds: [String]
    var comments: [Comment]
}

struct Creator: Hashable {
    let userId: String
    let nick: String
}

struct Comment: Hashable, Identifiable {
    let id: String
    var content: String
    let createdAt: String
    let creator: Creator
}
