//
//  BurgerHouse.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/24/24.
//

import Foundation

struct BurgerHouse: Hashable, Identifiable {
    let id: String
    let name: String
    let placeUrl: String
    let address: String
    let roadAddress: String
    let phone: String
    let x: String
    let y: String
}

struct BurgerPage: Hashable {
    let isEndPage: Bool
    let burgerHouses: [BurgerHouse]
}
