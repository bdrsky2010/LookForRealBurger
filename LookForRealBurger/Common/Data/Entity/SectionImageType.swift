//
//  SectionImageType.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/30/24.
//

import Foundation

import Differentiator

struct SectionImageType {
    var items: [Item]
}

extension SectionImageType: SectionModelType {
    typealias Item = String
    
    init(original: SectionImageType, items: [String]) {
        self = original
        self.items = items
    }
}
