//
//  GetBurgerHouse.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/27/24.
//

import Foundation

struct GetBurgerHouse {
    let burgerHouseId: String
    let name: String
    let totalRating: Int
    let hashtagName: String
    let longitude: String
    let latitude: String
    let roadAddress: String
    let phone: String
    let localId: String
    let productId: String
    let eatenUserIds: [String]
    let plannedUserIds: [String]
    let hashTags: [String]
    let reviewIds: [String]
    
    var avgRating: Int {
        Int(round(Double(totalRating) / Double(reviewIds.count)))
    }
}
