//
//  GetBurgerHouse.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/27/24.
//

import Foundation

struct GetBurgerHouse {
    let burgerHousePostId: String
    let name: String
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
    
    static let dummy = GetBurgerHouse(burgerHousePostId: "", name: "", hashtagName: "", longitude: "", latitude: "", roadAddress: "", phone: "", localId: "", productId: "", eatenUserIds: [], plannedUserIds: [], hashTags: [], reviewIds: [])
}
