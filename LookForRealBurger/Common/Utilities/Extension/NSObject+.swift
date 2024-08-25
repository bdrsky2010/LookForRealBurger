//
//  NSObject+.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/25/24.
//

import Foundation

protocol ReusableIdentifiable: AnyObject {
    static var identifier: String { get }
}

extension NSObject: ReusableIdentifiable {
    static var identifier: String {
        return String(describing: self)
    }
}
