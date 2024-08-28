//
//  BurgerMapHouse.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/28/24.
//

import Foundation

struct BurgerMapHouse {
    let burgerHousePostId: String
    let name: String
    let hashtagName: String
    let longitude: Double
    let latitude: Double
    let roadAddress: String
    let phone: String
    let localId: String
    let productId: String
    let eatenUserIds: [String]
    let plannedUserIds: [String]
    let hashTags: [String]
    let reviewIds: [String]
    
    var reviews: [BurgerHouseReview]
}
