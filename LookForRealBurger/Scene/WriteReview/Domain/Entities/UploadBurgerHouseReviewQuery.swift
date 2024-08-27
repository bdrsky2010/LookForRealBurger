//
//  UploadPostQuery.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/27/24.
//

import Foundation

struct UploadBurgerHouseReviewQuery {
    let title: String
    let rating: Int
    let content: String
    let burgerHousePostId: String
    let files: [String]
}
