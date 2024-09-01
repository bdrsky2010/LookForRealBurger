//
//  GetProfile.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/1/24.
//

import Foundation

struct GetProfile {
    let userId: String
    let nick: String
    let followers: [GetFollow]
    let following: [GetFollow]
    let posts: [String]
}
