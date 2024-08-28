//
//  SectionBurgerHouseReview.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/28/24.
//

import Foundation

import Differentiator

struct SectionBurgerHouseReview {
    var items: [Item]
}

extension SectionBurgerHouseReview: SectionModelType {
    typealias Item = BurgerHouseReview
    
    init(original: SectionBurgerHouseReview, items: [BurgerHouseReview]) {
        self = original
        self.items = items
    }
}
