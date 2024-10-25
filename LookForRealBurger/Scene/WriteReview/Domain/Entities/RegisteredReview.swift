//
//  UploadedReviewId.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/27/24.
//

import Foundation

struct RegisteredReview {
    let registerId: String
    let reviewID: String
    let createdAt: String
    let reviewer: Creator
    
    static let dummy = RegisteredReview(registerId: "", reviewID: "", createdAt: "", reviewer: Creator(userId: "me", nick: ""))
}
