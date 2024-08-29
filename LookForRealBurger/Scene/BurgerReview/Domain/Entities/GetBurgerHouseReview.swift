//
//  GetBurgerHouseReview.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/29/24.
//

import Foundation

// 포스트 페이지네이션 할 때 필요한 타입
struct GetBurgerHouseReview {
    var reviews: [BurgerHouseReview]
    let nextCursor: String
}
